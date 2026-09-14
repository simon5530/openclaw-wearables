#!/bin/sh

set -eu

CONFIG_PATH="${OPENCLAW_CONFIG_PATH:-$HOME/.openclaw/openclaw.json}"

echo "Even G2 × OpenClaw BYOA preflight"
echo

if command -v openclaw >/dev/null 2>&1; then
  echo "[ok] OpenClaw CLI is installed"
else
  echo "[missing] OpenClaw CLI"
fi

if [ -f "$CONFIG_PATH" ]; then
  echo "[ok] OpenClaw config exists"
else
  echo "[missing] OpenClaw config"
fi

if command -v jq >/dev/null 2>&1 && [ -f "$CONFIG_PATH" ]; then
  enabled="$(jq -r '.gateway.http.endpoints.chatCompletions.enabled // false' "$CONFIG_PATH")"
  bind="$(jq -r '.gateway.bind // "loopback"' "$CONFIG_PATH")"
  tailscale_mode="$(jq -r '.gateway.tailscale.mode // "off"' "$CONFIG_PATH")"
  echo "[info] Chat Completions enabled: $enabled"
  echo "[info] Gateway bind: $bind"
  echo "[info] Managed Tailscale mode: $tailscale_mode"
fi

if command -v tailscale >/dev/null 2>&1; then
  echo "[ok] Tailscale CLI is installed"
else
  echo "[missing] Tailscale CLI"
fi

if curl -fsS --max-time 3 http://127.0.0.1:18789/health >/dev/null 2>&1; then
  echo "[ok] Gateway health endpoint responds"
else
  echo "[check] Gateway health endpoint did not respond"
fi

http_code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 3 \
  http://127.0.0.1:18789/v1/models 2>/dev/null || true)"
case "$http_code" in
  401|403)
    echo "[ok] BYOA endpoint exists and rejects unauthenticated requests ($http_code)"
    ;;
  404)
    echo "[missing] BYOA endpoint is not enabled (404)"
    ;;
  200)
    echo "[warning] BYOA endpoint accepted an unauthenticated request"
    ;;
  *)
    echo "[check] BYOA endpoint returned ${http_code:-no response}"
    ;;
esac
