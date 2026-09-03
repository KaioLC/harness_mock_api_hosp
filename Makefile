.PHONY: repos-import repos-sync install-deps docker-build docker-up docker-logs docker-down

REPOS_FILE=core.repos

check-tools:
	@command -v vcs >/dev/null 2>&1 || { echo "Erro: vcstool não instalado. Instale com: sudo apt-get install python3-vcstool"; exit 1; }

repos-import: check-tools
	@echo "[1/2] Importando repositórios do manifesto..."
	vcs import . < $(REPOS_FILE)
	@echo "[2/2] Todos os repositórios foram importados com sucesso!"

repos-sync: check-tools
	@echo "Verifying updates"
	vcs status .
	@echo "Atualizando todos os repositórios do workspace..."
	vcs pull .

install-deps: 
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

