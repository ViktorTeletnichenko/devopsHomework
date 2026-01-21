# Task 12 - Load Balancers (Traefik)

## Run
```bash
docker compose up --build --scale web=4
```

## Test load balancing
```bash
for i in {1..10}; do curl -s http://localhost:8081/ | jq -r '.hostname'; done
```

## Traefik dashboard
- http://localhost:8082/
