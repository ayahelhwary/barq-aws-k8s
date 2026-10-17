#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../terraform"

KEY="${SSH_KEY:-$HOME/.ssh/barq-lab}"
IP="$(terraform output -raw control_plane_public_ip)"
RDS="$(terraform output -raw rds_endpoint | sed 's/:5432$//')"
USER_DB="$(terraform output -raw db_username 2>/dev/null || echo barq_admin)"
DB_NAME="$(terraform output -raw db_name 2>/dev/null || echo barq)"
PASS="$(awk -F'"' '/^db_password/ {print $2}' terraform.tfvars)"

REDIS_HOST="$(terraform output -raw redis_endpoint 2>/dev/null || true)"
REDIS_TOKEN="$(awk -F'"' '/^redis_auth_token/ {print $2}' terraform.tfvars)"

scp -r -i "$KEY" ../k8s ubuntu@"$IP":~/

ssh -i "$KEY" ubuntu@"$IP" bash -s <<EOF
set -e
cd ~/k8s
kubectl apply -f namespace.yaml
kubectl apply -f storage/local-path-provisioner.yaml
kubectl apply -f config/app-configmap.yaml
kubectl -n barq-assessment create secret generic barq-runtime-secret \
  --from-literal=DATABASE_URL="postgresql://${USER_DB}:${PASS}@${RDS}:5432/${DB_NAME}?sslmode=require" \
  --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f db/init-job.yaml
kubectl -n barq-assessment wait --for=condition=complete job/barq-db-init --timeout=180s
kubectl apply -f redis/
kubectl apply -f app/
kubectl apply -f nginx/
kubectl -n barq-assessment get pods -o wide
EOF
