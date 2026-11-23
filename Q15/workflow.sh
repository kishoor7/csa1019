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
git switch -c module-auth
printf 'Authentication module overview\n' > README.md
git add README.md
git commit -m 'Document authentication module'
printf 'def login(): return "Login module"\n' > auth.py
git add auth.py
git commit -m 'Add auth module'
git push origin module-auth
git switch main
git switch -c module-dashboard
printf 'Dashboard module overview\n' > README.md
git add README.md
git commit -m 'Document dashboard module'
printf 'def dashboard(): return "Dashboard module"\n' > dashboard.py
git add dashboard.py
git commit -m 'Add dashboard module'
git push origin module-dashboard
git switch main
git merge --no-ff module-auth -m 'Merge auth module locally'
if git merge --no-ff module-dashboard -m 'Merge dashboard module locally'; then echo 'Unexpected: no conflict'; exit 1; fi
git status --short
printf 'Authentication module overview\nDashboard module overview\n' > README.md
git add README.md
git commit -m 'Resolve module documentation conflict'
printf 'Team project\nBranches: module-auth, module-dashboard\nReview changes before merge; resolve conflicts on feature branches.\n' > README.md
git commit -am 'Document team workflow'
git push origin main
git log --oneline --graph --all -7
cat README.md
# Hosted PR review and approval need real GitHub collaborators.
