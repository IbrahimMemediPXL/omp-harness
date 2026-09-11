#!/usr/bin/env bash
set -euo pipefail
cd /workspace
umask 077
mkdir -p incoming projects output temp
if [[ -L .env ]]; then
  printf '%s\n' 'Refusing a symlink at .env; use a regular local file.' >&2
  exit 1
fi
if [[ ! -f .env ]]; then cp .env.example .env; fi
chmod 600 .env
test -w /home/agent/.omp
chmod 700 /home/agent/.omp
omp --version
printf '%s\n' 'OMP Harness is ready. Run make doctor, then make login.'
