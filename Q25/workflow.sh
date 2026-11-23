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
git clone -q --bare upstream.git fork.git
git clone -q fork.git feature-work
cd feature-work
git remote add upstream ../upstream.git
cd ../work
printf 'Existing team feature\n' > team.txt
git add team.txt
git commit -m 'Add team feature'
git push origin main
cd ../feature-work
git fetch upstream
git switch -c feature-report upstream/main
printf 'def report(): return "Report ready"\n' > report.py
git add report.py
git commit -m 'Add independent report feature'
git push origin feature-report
python -c 'from report import report; assert report()=="Report ready"; print(report())'
git log --oneline --graph --all -5
# Open a GitHub PR from your fork feature-report to upstream main; local fork does not create hosted PR.
