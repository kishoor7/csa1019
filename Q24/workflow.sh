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
git switch -c feature-login
cat > login.py <<'PYCODE'
def login(username, password):
    return username == "student" and password == "demo123"
PYCODE
python -c 'from login import login; assert login("student","demo123"); assert not login("student","wrong"); print("Both login tests passed")'
git add login.py
git commit -m 'Implement demo login'
git push origin feature-login
git switch main
git merge --no-ff feature-login -m 'Merge login feature locally'
git push origin main
git log --oneline --graph --all -4
# For actual GitHub: create and merge a pull request from feature-login to main.
# Demo credentials only; do not use this function for production authentication.
