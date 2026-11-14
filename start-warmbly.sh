#!/usr/bin/env bash
set -e

echo "1/4 Starting Warmbly containers..."
cd /opt/warmbly
sudo docker compose up -d

echo "2/4 Waiting for Web (5173) and API (8080) to become ready..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:5173 >/dev/null && curl -sf http://localhost:8080/v1/auth/config >/dev/null; then
    break
  fi
  sleep 2
done

echo "3/4 Setting forwarded ports to Public..."
for PORT in 5173 8080 5174 4000; do
  gh codespace ports visibility "${PORT}:public" --codespace "$CODESPACE_NAME" >/dev/null 2>&1 || true
done

echo "4/4 Warmbly is ready!"
echo ""
echo "Open Web UI : https://${CODESPACE_NAME}-5173.app.github.dev/"
echo "Open API    : https://${CODESPACE_NAME}-8080.app.github.dev/v1/auth/config"
echo ""
echo "Tip: If the browser shows a Network Error, open the Ports tab and ensure 5173 and 8080 show 'Public'."
