#!/usr/bin/env sh
set -euo pipefail

# Configuration - must match k8s/deployment.yaml image name
NAME="k8_demo"
USERNAME="emac2001"
IMAGE="$USERNAME/$NAME:latest"
SERVICE_NAME="k8-demo-service"
DEPLOYMENT_NAME="k8_demo"

command -v docker >/dev/null 2>&1 || { echo "docker command not found" >&2; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl command not found" >&2; exit 1; }

echo "Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

echo "Pushing image to registry: $IMAGE"
docker push "$IMAGE"

echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Waiting for deployment rollout: $DEPLOYMENT_NAME"
kubectl rollout status deployment/"$DEPLOYMENT_NAME" --timeout=120s || echo "Rollout status check returned non-zero";

echo "Pods:"
kubectl get pods

echo "Services:"
kubectl get services

echo "Service details for $SERVICE_NAME:"
kubectl get service "$SERVICE_NAME" -o wide || kubectl get services

exit 0