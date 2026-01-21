# Task 13 - K8s Troubleshooting

## Cluster
```bash
kind create cluster --name task13
kubectl cluster-info --context kind-task13
```

## Deploy
```bash
kubectl apply -f task13-k8s-troubleshooting/sample-app
```

## Port-forward
```bash
kubectl -n my-app port-forward svc/sample-app 8080:80
```
