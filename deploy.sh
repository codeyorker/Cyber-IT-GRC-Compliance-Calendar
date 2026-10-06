#!/usr/bin/env bash
# One-command deploy: ./deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

[ -f .env ] || { echo "ERROR: .env missing. Copy .env.example to .env and fill it in."; exit 1; }

if [ -d .git ]; then git pull --ff-only; fi

mkdir -p certs
if [ ! -f certs/fullchain.pem ]; then
  echo "No TLS cert found, creating a self-signed one (replace with company cert later)."
  openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -subj "/CN=grc-calendar" \
    -keyout certs/privkey.pem -out certs/fullchain.pem
fi

docker compose up -d --build
docker compose exec -T web python manage.py migrate --noinput
docker compose exec -T web python manage.py collectstatic --noinput
docker image prune -f >/dev/null
echo "Deploy finished."
