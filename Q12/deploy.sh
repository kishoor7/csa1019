#!/usr/bin/env bash
set -euo pipefail
: "${DOCKERHUB_USER:?Set Docker Hub username}"
IMAGE="$DOCKERHUB_USER/se-api:q12"
docker build -t "$IMAGE" .
docker login
docker push "$IMAGE"
sed "s|IMAGE_PLACEHOLDER|$IMAGE|g" deployment.yaml | kubectl apply -f -
kubectl apply -f service.yaml
kubectl rollout status deployment/lab-api
kubectl get pods,svc
# Access http://<node-ip>:30080/health
