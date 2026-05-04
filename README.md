# Infrastructure

Repositório de infraestrutura que orquestra a stack completa via Docker Compose: bancos de dados, RabbitMQ, microsserviços e Kong API Gateway.

## Conteúdo

- `docker-compose.yml` — definição de toda a stack com healthchecks e ordem de inicialização.
- `kong/kong.yml` — configuração declarativa do API Gateway (DB-less).
- `certs/` — scripts para gerar o par de chaves RSA usadas pelos JWT (RS256). As chaves geradas são ignoradas pelo git.
- `.env.example` — exemplo de variáveis de ambiente.
- `.github/workflows/deploy.yml` — workflow de deploy que faz checkout dos repos de microsserviço e constrói as imagens.

## Pré-requisitos

- Docker Desktop (Compose v2)
- OpenSSL (apenas para a primeira geração das chaves)

## Setup

```bash
# 1. Gerar chaves JWT (uma vez)
cd certs && ./generate-keys.sh   # ou ./generate-keys.ps1 no Windows
cd ..

# 2. (opcional) Personalizar credenciais
cp .env.example .env

# 3. Subir tudo
docker compose up -d --build
```

## Ordem de inicialização

Conforme `docs/05 - cicd.md`:

1. Bancos de dados (Mongo Users, Mongo Vehicles, Postgres Sales, Redis)
2. RabbitMQ
3. Microsserviços (UserApi, VehicleApi, SalesApi)
4. Kong API Gateway

Cada estágio aguarda o `service_healthy` do anterior.

## Portas expostas

| Componente | Porta |
|---|---|
| Kong (proxy) | 8000 |
| Kong (admin) | 8001 |
| UserApi (direto) | 5001 |
| VehicleApi (direto) | 5002 |
| SalesApi (direto) | 5003 |
| MongoDB Users | 27017 |
| MongoDB Vehicles | 27018 |
| PostgreSQL Sales | 5432 |
| Redis | 6379 |
| RabbitMQ AMQP | 5672 |
| RabbitMQ Management | 15672 |

## Encerrando

```bash
docker compose down              # mantém volumes
docker compose down -v           # apaga dados persistidos
```
