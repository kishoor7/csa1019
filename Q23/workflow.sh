#!/usr/bin/env bash
set -euo pipefail
export GIT_AUTHOR_NAME="Lab Student" GIT_AUTHOR_EMAIL="student@example.invalid" GIT_COMMITTER_NAME="Lab Student" GIT_COMMITTER_EMAIL="student@example.invalid"
D=$(mktemp -d)
trap 'rm -rf "$D"' EXIT
cd "$D"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
git init --bare -q --initial-branch=main upstream.git
git clone -q upstream.git work
cd work
printf 'Project overview\n' > README.md
git add README.md
git commit -qm 'Initial project'
git push -q origin main
cd ..
git clone upstream.git collaborator
cd collaborator
printf 'Collaborator added a feature description.\n' >> README.md
git add README.md
git commit -m 'Collaborator update'
git push origin main
cd ../work
git pull origin main
cat README.md
git log -2 --oneline
