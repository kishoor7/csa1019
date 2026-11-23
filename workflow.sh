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
# A bare clone models a fork; local merge models a PR, not a hosted PR.
cd ..
git clone -q --bare upstream.git fork.git
git clone -q fork.git fork-work
cd fork-work
git switch -c feature-greeting
printf 'def greet(name):\n    return "Hello " + name\n' > greeting.py
git add greeting.py
git commit -m 'Add greeting feature'
git push origin feature-greeting
# Simulate review feedback by adding an automated test.
python -c 'from greeting import greet; assert greet("Team")=="Hello Team"; print("Greeting test passed")'
printf 'from greeting import greet\nassert greet("Team") == "Hello Team"\n' > test_greeting.py
git add test_greeting.py
git commit -m 'Address review feedback with test'
git push origin feature-greeting
cd ../work
git remote add fork ../fork.git
git fetch fork feature-greeting
git merge --no-ff fork/feature-greeting -m 'Merge reviewed greeting feature locally'
git push origin main
git log --oneline --graph --all -5
# Real public GitHub PR: fork in GitHub, push branch, open Compare & pull request, request review and merge after approval.
