#!/usr/bin/env bash
set -euo pipefail
: "${DOCKERHUB_USER:?Set Docker Hub username}"
: "${POSTGRES_PASSWORD:?Set database password}"
FE="$DOCKERHUB_USER/se-frontend:q18"; BE="$DOCKERHUB_USER/se-backend:q18"
docker build -t "$FE" frontend
docker build -t "$BE" backend
docker login
docker push "$FE"; docker push "$BE"
kubectl create secret generic database-secret --from-literal=password="$POSTGRES_PASSWORD" --dry-run=client -o yaml | kubectl apply -f -
sed -e "s|FRONTEND_IMAGE|$FE|g" -e "s|BACKEND_IMAGE|$BE|g" kubernetes.yaml | kubectl apply -f -
for app in database backend frontend; do kubectl rollout status deployment/$app; done
kubectl get pods,svc
kubectl scale deployment/frontend --replicas=3
kubectl rollout status deployment/frontend
kubectl get pods,svc
# Access http://<node-ip>:30081. Database uses ephemeral lab storage.
