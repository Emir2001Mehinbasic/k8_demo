# k8_demo

## Project goal

This repository contains a small test Node.js application used to demonstrate local development, Docker usage, and a basic Kubernetes deployment flow. It is intended for testing and learning purposes only — not for production use.

## Quick start

Prerequisites:

- Node.js (recommended v20+)
- npm
- Docker
- kubectl
- Minikube (optional, for local Kubernetes)

Install dependencies:

```bash
npm install
```

Run locally (no Docker):

```bash
npm start        # production start
# or
npm run dev      # development (watch)
```

Docker (local):

```bash
docker compose up --build
```

Build and push image (manual):

```bash
docker build -t emac2001/k8_demo:latest .
docker push emac2001/k8_demo:latest
```

## Kubernetes deployment

There are deploy scripts for Windows PowerShell and Unix shell. The Kubernetes manifests are in the `k8s/` folder.

Windows (PowerShell):

```powershell
npm run deploy
```

Unix / Linux / macOS:

```bash
npm run deploy:unix
```

Direct with `kubectl`:

```bash
kubectl apply -f k8s/
kubectl get pods -w
kubectl get services
```

## Minikube specific

Option A — build image locally and use Minikube's Docker daemon (recommended for speed):

```bash
minikube start
eval "$(minikube -p minikube docker-env)"  # on PowerShell use: minikube -p minikube docker-env --shell powershell | Invoke-Expression
docker build -t emac2001/k8_demo:latest .
kubectl apply -f k8s/
kubectl get pods -w
```

Option B — build image then load into Minikube (if not using Minikube's Docker daemon):

```bash
docker build -t emac2001/k8_demo:latest .
minikube image load emac2001/k8_demo:latest
kubectl apply -f k8s/
kubectl get pods -w
```

## Notes

- The Kubernetes `Deployment` in `k8s/deployment.yaml` references image `emac2001/k8_demo:latest`. Make sure this image is available in your registry or loaded into Minikube before applying manifests.
- The app exposes probe endpoints `/healthz` (liveness) and `/readyz` (readiness). Ensure these routes respond correctly so probes pass.
- Service selector is `app: k8_demo` and target port is `3000`.

Useful kubectl commands:

```bash
kubectl logs -l app=k8_demo --tail=200
kubectl describe pod <pod-name>
kubectl rollout status deployment/k8_demo
kubectl get svc k8-demo-service -o wide
```

If you want the original README in Croatian preserved, tell me and I'll add `README.hr.md` with the Croatian text.
