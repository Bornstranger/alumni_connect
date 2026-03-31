.DEFAULT_GOAL := help

# ---------------------------------------------------------------------------
# Development
# ---------------------------------------------------------------------------

.PHONY: install
install: ## Install all dependencies (including dev)
	uv sync

.PHONY: run
run: ## Start Django dev server
	uv run python manage.py runserver

.PHONY: migrate
migrate: ## Run database migrations
	uv run python manage.py migrate

.PHONY: migrations
migrations: ## Create new migrations
	uv run python manage.py makemigrations

.PHONY: superuser
superuser: ## Create a Django superuser
	uv run python manage.py createsuperuser

.PHONY: shell
shell: ## Open Django shell
	uv run python manage.py shell

# ---------------------------------------------------------------------------
# Code Quality
# ---------------------------------------------------------------------------

.PHONY: lint
lint: ## Run ruff linter
	uv run ruff check .

.PHONY: lint-fix
lint-fix: ## Run ruff linter with auto-fix
	uv run ruff check . --fix

.PHONY: format
format: ## Format code with ruff
	uv run ruff format .

.PHONY: format-check
format-check: ## Check code formatting
	uv run ruff format --check .

.PHONY: typecheck
typecheck: ## Run mypy type checker
	uv run mypy config/

.PHONY: check
check: lint format-check typecheck ## Run all code quality checks
	uv run python manage.py check --fail-level WARNING

# ---------------------------------------------------------------------------
# Testing
# ---------------------------------------------------------------------------

.PHONY: test
test: ## Run tests with coverage
	uv run pytest

.PHONY: test-no-cov
test-no-cov: ## Run tests without coverage
	uv run pytest --no-cov

.PHONY: test-serial
test-serial: ## Run tests without parallelism (useful for debugging)
	uv run pytest -n 0

# ---------------------------------------------------------------------------
# Security
# ---------------------------------------------------------------------------

.PHONY: audit
audit: ## Audit dependencies for vulnerabilities
	uv run pip-audit

.PHONY: check-deploy
check-deploy: ## Run Django deployment checklist
	uv run python manage.py check --deploy --fail-level WARNING

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------

.PHONY: up
up: ## Start all Docker services
	docker compose up -d --build

.PHONY: down
down: ## Stop all Docker services
	docker compose down

.PHONY: down-v
down-v: ## Stop services and remove volumes
	docker compose down -v

.PHONY: logs
logs: ## Tail Docker logs
	docker compose logs -f

.PHONY: docker-migrate
docker-migrate: ## Run migrations inside Docker
	docker compose exec app python manage.py migrate

# ---------------------------------------------------------------------------
# Git Hooks
# ---------------------------------------------------------------------------

.PHONY: hooks
hooks: ## Install pre-commit hooks
	uv run pre-commit install --hook-type pre-commit --hook-type commit-msg

.PHONY: pre-commit
pre-commit: ## Run pre-commit on all files
	uv run pre-commit run --all-files

# ---------------------------------------------------------------------------
# CI (run all checks locally before pushing)
# ---------------------------------------------------------------------------

.PHONY: ci
ci: check test audit ## Run the full CI pipeline locally

# ---------------------------------------------------------------------------
# Help
# ---------------------------------------------------------------------------

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
