#!/usr/bin/env bash
# Read-only audit of secondary worktrees. Session ownership is unverified, so
# every row is held regardless of merge or PR state. No fetch or deletion runs.
# Usage: worktree-audit.sh [-b|--base <ref>] [--no-pr] [repo-path]
#   -b selects the locally available merge-check ref.
#   --no-pr skips the optional read-only forge query.
#   Without -b, use origin/HEAD, origin/main, then origin/master.
set -u
export GIT_OPTIONAL_LOCKS=0

base=""
query_pr=yes
while [ $# -gt 0 ]; do
	case "$1" in
	-b|--base) [ $# -ge 2 ] || { echo "error: $1 needs a ref" >&2; exit 2; }; base="$2"; shift 2 ;;
	--no-pr) query_pr=no; shift ;;
	-h|--help) sed -n '2,/^set -u/p' "$0" | sed '$d; s/^# \{0,1\}//'; exit 0 ;;
	--) shift; break ;;
	-*) echo "error: unknown option: $1" >&2; exit 2 ;;
	*) break ;;
	esac
done
[ $# -le 1 ] || { echo "error: expected at most one repo path" >&2; exit 2; }

repo="${1:-$(git rev-parse --show-toplevel 2>/dev/null)}"
[ -n "$repo" ] || { echo "error: not in a git repo; pass a repo path" >&2; exit 1; }
cd "$repo" || exit 1
git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not a git repo: $repo" >&2; exit 1; }

worktrees=()
while IFS= read -r -d '' field; do
	case "$field" in worktree\ *) worktrees+=("${field#worktree }") ;; esac
done < <(git worktree list --porcelain -z)
[ ${#worktrees[@]} -gt 0 ] || { echo "error: no worktrees found" >&2; exit 1; }
main_wt="${worktrees[0]}"

if [ -z "$base" ]; then
	for candidate in "$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)" origin/main origin/master; do
		if [ -n "$candidate" ] && git rev-parse --verify --quiet "$candidate^{commit}" >/dev/null; then
			base="$candidate"
			break
		fi
	done
	[ -n "$base" ] || { echo "error: no local base ref; pass -b <ref>" >&2; exit 1; }
	echo "warn: no -b given; MERGED checks against $base" >&2
fi
git rev-parse --verify --quiet "$base^{commit}" >/dev/null 2>&1 || { echo "error: base ref not found locally: $base" >&2; exit 1; }
echo "note: no fetch performed; merge and remote columns use local refs" >&2
echo "note: pinned, active, and managed Codex session ownership is unverified; every row is held" >&2

prs=$(mktemp)
trap 'rm -f "$prs"' EXIT
if [ "$query_pr" = yes ]; then
	if command -v origin >/dev/null 2>&1 \
		&& raw=$(origin pr list --author "@me" --state all --limit 1000 \
			--json number,status,headRef 2>/dev/null); then
		printf '%s' "$raw" | jq '[.[] | {number, state: .status, head: .headRef}]' > "$prs" 2>/dev/null
	elif command -v gh >/dev/null 2>&1 \
		&& raw=$(gh pr list --author "@me" --state all --limit 1000 \
			--json number,state,headRefName 2>/dev/null); then
		printf '%s' "$raw" | jq '[.[] | {number, state: (.state | ascii_downcase), head: .headRefName}]' > "$prs" 2>/dev/null
	fi
fi
[ -s "$prs" ] || echo "[]" > "$prs"
now=$(date +%s)

tsv_cell() {
	local value="$1"
	local tab_escape='\t' carriage_escape='\r' newline_escape='\n'
	value="${value//\\/\\\\}"
	value="${value//$'\t'/$tab_escape}"
	value="${value//$'\r'/$carriage_escape}"
	value="${value//$'\n'/$newline_escape}"
	printf '%s' "$value"
}

printf '# base: %s\n' "$base"
printf 'SIZE\tAGE\tMERGED\tDIRTY\tREMOTE\tPR\tLAST_CHAT\tBUCKET\tWORKTREE\n'
for wt in "${worktrees[@]}"; do
	[ "$wt" = "$main_wt" ] && continue
	size=$(du -sh "$wt" 2>/dev/null | awk '{print $1}')
	[ -n "$size" ] || size="?"
	head=$(git -C "$wt" rev-parse HEAD 2>/dev/null || echo "")
	head_ts=$(git -C "$wt" log -1 --format='%ct' HEAD 2>/dev/null || echo 0)
	if [ "$head_ts" -gt 0 ] 2>/dev/null; then age="$(( (now - head_ts) / 86400 ))d"; else age="?"; fi
	if [ -n "$head" ] && git merge-base --is-ancestor "$head" "$base" 2>/dev/null; then merged=YES; else merged=no; fi
	if porcelain=$(git -C "$wt" status --porcelain --untracked-files=all 2>/dev/null); then
		if [ -z "$porcelain" ]; then dirty=clean
		elif printf '%s\n' "$porcelain" | grep -qv '^??'; then
			dirty="wip:$(printf '%s\n' "$porcelain" | grep -cv '^??')"
		else dirty="scratch:$(printf '%s\n' "$porcelain" | grep -c '^??')"; fi
	else dirty=unknown; fi
	branch=$(git -C "$wt" symbolic-ref --quiet --short HEAD 2>/dev/null || echo "")
	if [ -z "$branch" ]; then remote=detached
	elif git -C "$wt" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
		if [ "$(git -C "$wt" rev-parse "origin/$branch" 2>/dev/null)" = "$head" ]; then remote=pushed
		else remote="ahead$(git -C "$wt" rev-list --count "origin/$branch..HEAD" 2>/dev/null)"; fi
	else remote=no-remote; fi
	pr=$([ -n "$branch" ] && jq -r --arg b "$branch" \
		'.[] | select(.head==$b) | "#\(.number)/\(.state)"' "$prs" 2>/dev/null | head -1)
	[ -n "$pr" ] || pr="-"
	printf '%s\t%s\t%s\t%s\t%s\t%s\tunknown\thold-session-unverified\t%s\n' \
		"$size" "$age" "$merged" "$dirty" "$remote" "$pr" "$(tsv_cell "$wt")"
done | sort -t$'\t' -k1,1 -rh
