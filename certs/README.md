# Chaves JWT (RS256)

Antes de subir o ambiente, gere o par de chaves RSA assimétrico usado para emitir e validar tokens JWT.

## Linux/macOS

```bash
./generate-keys.sh
```

## Windows (PowerShell)

```powershell
./generate-keys.ps1
```

Os arquivos resultantes (`jwt-private.pem` e `jwt-public.pem`) são montados nos containers via volume e **não devem ser comitados**.

- `UserApi` lê tanto a chave privada (assinatura) quanto a pública (JWKS)
- `VehicleApi` e `SalesApi` leem apenas a chave pública (validação)
