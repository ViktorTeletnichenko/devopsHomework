# Manifest errors

- Deployment namespace set to `me-app` while Namespace is `my-app`.
- Container memory requests/limits set to 64Gi/128Gi (unschedulable on small clusters).
- Service `targetPort` set to 8081 while container listens on 8080.
- Image tag `gitopsbook/sample-app:v1` does not exist on Docker Hub.
