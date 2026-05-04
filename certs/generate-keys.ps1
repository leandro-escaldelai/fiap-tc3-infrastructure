# Gera o par de chaves RSA usado para assinar/verificar tokens JWT (RS256).
# Requisitos: OpenSSL no PATH. Resulta em jwt-private.pem e jwt-public.pem nesta pasta.

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Definition

$privatePath = Join-Path $here 'jwt-private.pem'
$publicPath  = Join-Path $here 'jwt-public.pem'

if (Test-Path $privatePath) {
    Write-Host "jwt-private.pem já existe — apague o arquivo manualmente para regerar."
    exit 0
}

& openssl genpkey -algorithm RSA -out $privatePath -pkeyopt rsa_keygen_bits:2048
& openssl rsa -in $privatePath -pubout -out $publicPath

Write-Host "Chaves geradas em $here"
