import { createHash } from 'node:crypto';
import { cpSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, renameSync, rmSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const source = path.dirname(fileURLToPath(import.meta.url));
const cacheRoot = process.env.PSTACK_CACHE_DIR || path.join(process.env.XDG_CACHE_HOME || path.join(homedir(), '.cache'), 'pstack');
const hash = createHash('sha256');
function addFiles(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
    if (entry.name === 'node_modules') continue;
    const full = path.join(directory, entry.name);
    if (entry.isDirectory()) addFiles(full);
    else if (entry.isFile()) hash.update(path.relative(source, full)).update('\0').update(readFileSync(full)).update('\0');
  }
}
addFiles(source);
const key = hash.digest('hex');
const cache = path.join(cacheRoot, 'poteto-tools', key);
mkdirSync(path.dirname(cache), { recursive: true });
if (!existsSync(path.join(cache, '.source-key'))) {
  const staging = mkdtempSync(path.join(path.dirname(cache), '.prepare-'));
  try {
    cpSync(source, staging, { recursive: true, preserveTimestamps: true });
    writeFileSync(path.join(staging, '.source-key'), key + '\n');
    try { renameSync(staging, cache); }
    catch (error) { if (!existsSync(path.join(cache, '.source-key'))) throw error; }
  } finally {
    rmSync(staging, { recursive: true, force: true });
  }
}
if (readFileSync(path.join(cache, '.source-key'), 'utf8').trim() !== key) throw new Error('pstack runtime cache key mismatch');

let bun = 'bun';
if (spawnSync(bun, ['--version'], { stdio: 'ignore' }).status !== 0) {
  const toolchain = path.join(cacheRoot, 'toolchains', 'bun-1.4.4');
  bun = path.join(toolchain, 'node_modules', '.bin', 'bun');
  if (!existsSync(bun)) {
    mkdirSync(toolchain, { recursive: true });
    process.stderr.write('pstack: preparing Bun 1.4.4 in the runtime cache. Network access is required.\n');
    const installed = spawnSync('npm', ['install', '--prefix', toolchain, '--no-audit', '--no-fund', '--save-exact', 'bun@1.4.4'], { stdio: 'inherit' });
    if (installed.status !== 0) process.exit(installed.status || 1);
  }
}
const child = spawnSync(bun, [path.join(cache, 'watch-pr', 'entry.ts'), ...process.argv.slice(2)], { stdio: 'inherit', env: process.env });
if (child.error) process.stderr.write(child.error.message + '\n');
process.exit(child.status ?? 1);
