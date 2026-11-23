#!/usr/bin/env bash
set -euo pipefail
: "${DOCKERHUB_USER:?Set Docker Hub username}"
# Run on another machine.
docker pull "$DOCKERHUB_USER/se-static:q17"
docker run --rm -d -p 8080:80 "$DOCKERHUB_USER/se-static:q17"
curl -fsS http://localhost:8080
