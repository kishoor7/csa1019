#!/usr/bin/env bash
set -euo pipefail
: "${DOCKERHUB_USER:?Set Docker Hub username}"
IMAGE="$DOCKERHUB_USER/se-todo:q16"
docker build -t "$IMAGE" .
docker run --rm "$IMAGE" python -m unittest -v
docker run --rm -d --name se-todo -p 8080:5000 "$IMAGE"
curl -fsS -X POST -H 'Content-Type: application/json' -d '{"title":"Study Docker"}' http://localhost:8080/tasks
curl -fsS -X PATCH http://localhost:8080/tasks/1
curl -fsS http://localhost:8080/tasks
docker login
docker push "$IMAGE"
