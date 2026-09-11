"""Static harness checks; no credentials, network calls, or OMP required."""
import json
import subprocess
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[1]


def run(*args):
    subprocess.run(args, cwd=ROOT, check=True)


def main():
    container = json.loads((ROOT / '.devcontainer/devcontainer.json').read_text())
    assert container['remoteUser'] == container['containerUser'] == 'agent'
    assert container['workspaceFolder'] == '/workspace'
    assert len(container['mounts']) == 1
    assert container['mounts'][0].endswith('target=/home/agent/.omp,type=volume')
    assert '--cap-drop=ALL' in container['runArgs']
    assert '--security-opt=no-new-privileges:true' in container['runArgs']
    mcp = json.loads((ROOT / '.omp/mcp.json').read_text())
    assert mcp['mcpServers'] == {}
    baseline = yaml.safe_load((ROOT / '.omp/config.yml').read_text())
    assert baseline['task']['maxConcurrency'] == 3
    for folder in ['.omp', '.github']:
        for path in (ROOT / folder).rglob('*.yml'):
            yaml.safe_load(path.read_text())
    for path in (ROOT / '.omp/skills').glob('*/SKILL.md'):
        fields = yaml.safe_load(path.read_text().split('---', 2)[1])
        assert fields['name'] and fields['description'], path
    for profile, mode in [('safe', 'always-ask'), ('normal', 'write'), ('yolo', 'yolo')]:
        config = yaml.safe_load((ROOT / f'.omp/profiles/{profile}.yml').read_text())
        assert config['tools']['approvalMode'] == mode
        assert config['task']['maxConcurrency'] == 3, profile
        assert config['computer']['enabled'] is False
        assert config['browser']['enabled'] is False
        if profile != 'yolo':
            assert config['tools']['approval']['bash'] == 'prompt'
            assert config['tools']['approval']['eval'] == 'prompt'
    for path in (ROOT / '.devcontainer').iterdir():
        if path.suffix == '.sh' or path.name.startswith('omp-'):
            run('bash', '-n', str(path))
            assert path.stat().st_mode & 0o111, f'Not executable: {path}'
    run('make', 'help')
    for target in ['init', 'login', 'logout', 'doctor', 'safe', 'normal', 'yolo', 'profiles']:
        run('make', '-n', target)
    run('git', 'diff', '--check')
    run('git', 'diff', '--cached', '--check')
    for path in ['.env', '.env.local', 'incoming/private.csv', 'projects/example/file', 'output/report.txt', 'temp/work.txt']:
        run('git', 'check-ignore', '-q', path)
    print('Static validation passed. Docker, OAuth and runtime behavior are NOT tested here.')


if __name__ == '__main__':
    main()
