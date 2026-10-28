# pstack-codex

**pstack의 스킬 58개를 Codex에서 사용합니다.** 코드 탐색, 설계, 구현, 동작 검증을 위한 작업 절차를 제공합니다.

[English](README.md) · [Codex 실행 지침](CODEX.md) · [원본](https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack) · [MIT](LICENSE)

`cursor/plugins`에 공개된 **Lauren Tan의 pstack**을 바탕으로 만든 비공식 커뮤니티 이식본입니다. 독립적으로 관리하며 Lauren Tan, Cursor, OpenAI의 공식 프로젝트나 보증을 받은 프로젝트가 아닙니다.

## 설치

### 1. Codex 준비

이미 Codex를 사용한다면 2단계로 넘어갑니다. 처음 설치한다면 [공식 Codex CLI 시작 안내](https://learn.chatgpt.com/docs/codex/cli)를 따릅니다. macOS/Linux에서는 다음 명령을 사용할 수 있습니다.

```sh
curl -fsSL https://chatgpt.com/codex/install.sh | sh
codex login
```

브라우저에서 로그인을 마칩니다. 다른 인증 방식은 [공식 인증 안내](https://learn.chatgpt.com/docs/auth)에 있습니다. 위 명령은 Codex 자체를 설치하며, 다음 단계에서 pstack을 추가합니다.

### 2. 마켓플레이스 등록과 pstack 설치

```sh
codex plugin marketplace add gaejabong/pstack-codex
codex plugin add pstack@pstack-codex
```

설치 후 새 Codex 대화를 시작합니다. 데스크톱 앱에서 마켓플레이스가 나타나지 않으면 새로고침하거나 앱을 다시 시작합니다. CLI가 이 저장소를 마켓플레이스로 등록하고 스킬 58개와 공통 자료를 담은 `pstack` 플러그인을 설치합니다. 직접 저장소를 복제하거나 링크를 만들 필요가 없습니다. 자세한 명령은 [공식 플러그인 안내](https://learn.chatgpt.com/docs/developer-commands#codex-plugin)에 있습니다.

이 저장소가 제공하는 마켓플레이스는 OpenAI의 공개 Plugins Directory와 별개입니다. 이전에 수동으로 설치했다면 중복 등록을 피하도록 기존 링크의 대상을 확인한 뒤 pstack 스킬 링크만 제거합니다. 다음처럼 스킬을 호출합니다.

```text
$pstack:poteto-mode 이 버그를 재현하고 수정한 뒤 실제 동작을 검증해줘.
$pstack:how 이 모듈의 요청 처리 흐름을 설명해줘.
$pstack:poteto-help 이 PR을 검토하려면 어떤 스킬이 좋을까?
```

## 유지한 내용과 바꾼 동작

| 항목 | 이식 결과 |
| --- | --- |
| 구성 | 스킬 58개 전체(작업 절차 34개·개발 원칙 24개), 플레이북 23개, 참조 문서와 보조 자료를 유지했습니다. |
| 작업 방식 | 원본의 작업 구조, 검토 기준, 검증 근거 요구를 유지하고 실행 환경에 의존하는 지침을 바꿨습니다. |
| 이름과 선택 | `pstack` 플러그인이 `pstack:…` 접두사를 제공합니다. SKILL.md에는 접두사 없는 이름을 쓰며 디렉터리는 `pstack-…`를 유지합니다. 57개 스킬은 명시적으로 호출하고 설정 스킬은 자동 선택할 수 있습니다. |
| 에이전트 위임 | 현재 Codex의 위임 도구와 공통 에이전트 프롬프트를 사용합니다. 위임할 수 없으면 순차 실행하고 그 한계를 밝힙니다. |
| 모델과 기록 | 기본적으로 현재 모델·추론 수준을 상속합니다. 선택적 설정은 `~/.agents/pstack/models.json`을 사용하며, 기록 조회는 관련 작업공간과 기간으로 제한합니다. |
| 보조 도구와 외부 작업 | Watcher 실행기는 별도 캐시를 사용합니다. Worktree 감사는 fetch·삭제를 하지 않고 소유권을 확인할 수 없으면 정리를 보류합니다. 외부 작업은 사용자에게 맡겨진 범위와 실행 환경의 규칙을 따릅니다. |

전체 목록은 [스킬 폴더](skills)에서 확인하거나 `$pstack:poteto-help`에 물어볼 수 있습니다. 공통 실행 규칙은 [CODEX.md](CODEX.md)에 있습니다.

## 지원 제한과 필요한 도구

- macOS에서 확인했습니다. Linux와 Windows에서의 실행은 검증하지 않았습니다. 마켓플레이스 명령을 지원하는 최신 Codex 클라이언트가 필요합니다. 스킬 메타데이터에는 표준 이름을 사용하고 Codex가 플러그인 접두사를 붙입니다.
- 모델 지정, 병렬 실행, 기록 접근, 자동화 지원은 실행 환경에 따라 다릅니다. 같은 모델로 수행한 독립 검토는 그대로 설명하며, 서로 다른 모델의 검토나 지속되는 UI 모드를 보장하지 않습니다.
- PR watcher에는 Node.js가 필요합니다. 기존 Bun을 사용하거나 npm으로 Bun 1.4.4를 `~/.cache/pstack/`에 준비합니다. `PSTACK_CACHE_DIR`로 경로를 바꿀 수 있으며 최초 실행 시 도구·의존성을 내려받습니다.
- Statechart 검사에는 지원되는 Node/Bun/Deno와 Java/TLC가 필요하며 SVG 렌더링에는 Pele을 사용합니다. 외부 서비스 작업에는 별도의 도구·인증 정보가 필요하고 네트워크가 필요할 수 있습니다.
- Cursor 전용 서비스를 자동으로 재현하지 않습니다. `cursor-team-kit`은 포함하지 않으며 benny 자동화 자료는 활성화하지 않은 원본 참고용입니다. Bot UI에는 실제 webhook이나 구축을 요청한 worker bridge가 필요합니다.

[원본 가이드](docs/guide/README.md)와 Claude Code 어댑터에는 해당 제품의 참고 설명이 남아 있습니다. Codex에서는 이 README와 [CODEX.md](CODEX.md)를 따릅니다.

## 검증 범위

macOS의 Codex CLI 0.165.0에서 네이티브 마켓플레이스·플러그인 해석, 포함된 스킬 58개 인식, 표준 스킬 메타데이터와 로컬 자료 참조를 확인했습니다. 패키지 구성과 검색 동작을 확인한 결과입니다. Cursor와 모든 작업이 동등하게 동작하는지, 모든 외부 서비스에서 실행되는지, 코딩 성능이 향상되는지까지 검증한 것은 아닙니다.

## 업데이트와 제거

마켓플레이스를 갱신하고 현재 플러그인 패키지를 설치합니다.

```sh
codex plugin marketplace upgrade pstack-codex
codex plugin add pstack@pstack-codex
```

업데이트 후 새 대화를 시작합니다. 관리자는 변경을 배포할 때 `plugin.json`의 버전을 올립니다. 플러그인 제거는 `codex plugin remove pstack@pstack-codex`, 마켓플레이스 등록 해제는 `codex plugin marketplace remove pstack-codex`로 합니다. 선택적으로 만든 `~/.agents/pstack/models.json`은 플러그인과 별도로 관리됩니다.

## 출처와 라이선스

pstack **0.15.36**, 커밋 `c742dd61706fbacc1b95f1a20b7b988cf096ce6c`를 바탕으로 만들었습니다. 원본 저작권 표시는 Copyright (c) 2026 Lauren Tan이며, Codex 이식 기여는 Copyright (c) 2026 gaejabong and contributors로 표시합니다.

원본 자료의 [MIT 라이선스](LICENSE)를 유지합니다. Codex용 수정·추가 부분도 MIT로 제공하며 이식 기여 표시는 그 부분에만 적용합니다. 원본 고지를 보존했습니다. 자세한 출처는 [NOTICE.md](NOTICE.md)에 있습니다.
