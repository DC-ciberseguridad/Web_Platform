.PHONY: api-dev api-docker up down build logs

# ===== LOCAL DEV =====
api-dev:
	cd services/api && python -m uvicorn app.main:app --reload

# ===== DOCKER =====
build:
	docker compose -f docker/docker-compose.local.yml build

up:
	docker compose -f docker/docker-compose.local.yml up

down:
	docker compose -f docker/docker-compose.local.yml down -v

logs:
	docker compose -f docker/docker-compose.local.yml logs -f