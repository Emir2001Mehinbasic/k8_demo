Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$NAME = "k8_demo"
$USERNAME = "emac2001"
$IMAGE = "$USERNAME/$NAME:latest"
$SERVICE_NAME = "k8-demo-service"

Write-Host "Building Docker image ..."
docker build -t $IMAGE .

Write-Host "Pushing img to Docker Hub ..."
docker push $IMAGE

Write-Host "Applying Kubernetes manifests ..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

Write-Host "Getting pods ..."
kubectl get pods

Write-Host "Getting services ..."
kubectl get services

Write-Host "Fetching the main service"
kubectl get services $SERVICE_NAME

exit 0
