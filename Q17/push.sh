#!/usr/bin/env bash
set -euo pipefail
: "${DOCKERHUB_USER:?Set Docker Hub username}"
IMAGE="$DOCKERHUB_USER/se-static:q17"
docker build -t se-static:q17 .
docker tag se-static:q17 "$IMAGE"
docker login
docker push "$IMAGE"
