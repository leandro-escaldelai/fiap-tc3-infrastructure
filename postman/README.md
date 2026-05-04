# Postman — Tech Challenge

Coleção e environment prontos para importar no Postman/Insomnia.

## Arquivos

- `TechChallenge.postman_collection.json` — todos os endpoints (UserApi, VehicleApi, SalesApi)
- `TechChallenge.postman_environment.json` — variáveis padrão para o ambiente local

## Como importar

1. Abra o Postman → **Import** → arraste os dois arquivos.
2. No canto superior direito, selecione o environment **"Tech Challenge — Local"**.
3. Garanta que a stack está rodando (`docker compose up -d` em `infrastructure/`).

## Fluxo recomendado (ponta a ponta)

Execute os requests **na ordem**. Os scripts de teste preenchem automaticamente as variáveis necessárias para os requests seguintes.

| # | Request | O que faz |
|---|---|---|
| 1 | **UserApi → Cadastrar Proprietário** | Cria o vendedor (idempotente: aceita 409) |
| 2 | **UserApi → Cadastrar Comprador** | Cria o comprador |
| 3 | **UserApi → Login do Proprietário** | Salva `tokenOwner` e `userIdOwner` |
| 4 | **UserApi → Login do Comprador** | Salva `tokenBuyer` e `userIdBuyer` |
| 5 | **VehicleApi → Cadastrar Veículo** | Salva `vehicleId` |
| 6 | **VehicleApi → Listar Disponíveis** | Confirma listagem ordenada por preço asc |
| 7 | **SalesApi → Iniciar Venda** | Salva `saleId` (status `Iniciada`) |
| 8 | **SalesApi → Concluir Venda** | Status → `Concluida`; publica `VehicleSold` no RabbitMQ |
| 9 | **VehicleApi → Listar Vendidos** | Após o consumer processar, o veículo aparece aqui |

> Para automatizar o fluxo inteiro, use **Collection Runner** (executa todos os requests sequencialmente).

## Variáveis

| Variável | Descrição | Como é preenchida |
|---|---|---|
| `baseUrl` | URL do Kong API Gateway | Manual (default `http://localhost:8000`) |
| `userApiUrl` / `vehicleApiUrl` / `salesApiUrl` | Acesso direto sem Kong (úteis para health checks) | Manual |
| `tokenOwner` / `tokenBuyer` | JWT após login | Auto (script de teste do request de login) |
| `userIdOwner` / `userIdBuyer` | ID dos usuários | Auto (cadastro/login) |
| `vehicleId` | Veículo cadastrado | Auto (cadastro de veículo) |
| `saleId` | Venda iniciada | Auto (iniciar venda) |

## CPFs de teste

A coleção usa CPFs válidos para os fixtures:

- Proprietário: `45317828791`
- Comprador: `39053344705`
