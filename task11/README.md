# Task 11 - Kubernetes

## Cluster
- kind config: task11/cluster/kind-config.yaml
- cluster name: task11

Commands used:
- kubectl version --output=yaml
- kubectl get nodes -o wide
- kubectl get pods -n kube-system -l k8s-app=kindnet -o wide

## Nginx ReplicaSet
Manifest: task11/manifests/nginx-replicaset.yaml

Apply:
- kubectl apply -f task11/manifests/nginx-replicaset.yaml

Check pods with node placement:
- kubectl get pods -n front-end -o wide

Port-forward to access Nginx:
- kubectl -n front-end port-forward svc/nginx-service 8080:80
