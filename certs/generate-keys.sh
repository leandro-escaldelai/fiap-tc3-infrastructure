#!/usr/bin/env bash
# Gera o par de chaves RSA usado para assinar/verificar tokens JWT (RS256).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$HERE/jwt-private.pem" ]]; then
  echo "jwt-private.pem já existe — apague manualmente para regerar."
  exit 0
fi

openssl genpkey -algorithm RSA -out "$HERE/jwt-private.pem" -pkeyopt rsa_keygen_bits:2048
openssl rsa -in "$HERE/jwt-private.pem" -pubout -out "$HERE/jwt-public.pem"
echo "Chaves geradas em $HERE"
