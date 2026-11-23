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
git switch -c feature-readme
printf 'Feature description\n' > README.md
git commit -am 'Feature edit'
git push origin feature-readme
git switch main
printf 'Main description\n' > README.md
git commit -am 'Main edit'
git push origin main
git pull origin main
git switch feature-readme
if git merge main; then echo 'Unexpected: no conflict'; exit 1; fi
git status --short
cat README.md
printf 'Main description\nFeature description\n' > README.md
git add README.md
git commit -m 'Resolve README merge conflict'
git push origin feature-readme
git log --oneline --graph --all -5
# Open a hosted pull request from feature-readme to main on GitHub after pushing there.
