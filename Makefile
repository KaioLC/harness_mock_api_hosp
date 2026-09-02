.PHONY: repos-import repos-pull install-deps docker-build docker-up docker-logs docker-down clean-cache

REPOS_FILE: core.repos

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-  
  15s\033[0m %s\n", $$1, $$2}'

check-tools:
	@command -v vcs >/dev/null 2>&1 || { echo "Erro: vcstool não instalado. Instale com: sudo apt-get install python3-vcstool"; exit 1; }

repos-import: check-tools
	@echo "[1/2] Importando repositórios do manifesto..."
	vcs import . < $(REPOS_FILE)
	@echo "[2/2] Todos os repositórios foram importados com sucesso!"

sync: check-tools
	@echo "Verifying updates"
	vcs status .
	@echo "Atualizando todos os repositórios do workspace..."
	vcs pull .

install: 
	@echo "[1/2] Instalando dependências da API..."
	cd fhir_mock_api && uv sync --extra 
	@echo "[2/2] Instalando dependências do Harness..."
	cd harness_fhir && pnpm
	@echo "Workspace 100% pronto para desenvolvimento!"

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-logs:
	docker compose logs -f

docker-down:
	docker compose down

