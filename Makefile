# configuration (from .env)

ifneq (,$(wildcard .env))
    include .env
    export
endif

# help

.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:' Makefile | grep -v '\.PHONY' | cut -d: -f1 

# package management

.PHONY: update-dependencies
update-dependencies:
	uv self update
	uv sync --upgrade
	uv run pre-commit autoupdate
	uv run pre-commit install

# code quality

.PHONY: check-lockfile-consistency
check-lockfile-consistency:
	uv lock --check

.PHONY: lint
lint:
	uv run ruff check

.PHONY: format
format:
	uv run ruff format

.PHONY: type-check
type-check:
	uv run mypy

.PHONY: test
test: type-check
	uv run pytest --cov src/

.PHONY: run-checks
run-checks: check-lockfile-consistency lint format type-check test
	@echo "all checks passed!"

# pre-commit hooks

.PHONY: install-pre-commit-hooks
install-pre-commit-hooks: update
	uv run pre-commit install

.PHONY: update-pre-commit-hooks
update-pre-commit-hooks:
	uv run pre-commit autoupdate

.PHONY: run-pre-commit-hooks
run-pre-commit-hooks: update-pre-commit-hooks
	uv run pre-commit run --all-files

# local development

.PHONY: run-dev
run-dev: run-checks
	uv run uvicorn src.fastapi_template.app:app --host $(HOST) --port $(PORT) --reload

# docker

.PHONY: docker-build
docker-build: run-checks
	docker build . -t ${IMAGE_NAME}

.PHONY: docker-run
docker-run: docker-build
	docker run -p ${HOST}:${PORT}:${PORT} --env-file .env ${IMAGE_NAME}

# kubernetes

.PHONY: kubernetes-deploy
kubernetes-deploy: run-checks
	skaffold run

# cleanup

.PHONY: clean
clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 
	rm -rf .venv .pytest_cache .ruff_cache .mypy_cache .coverage dist
	docker image rm -f $$(docker images ${IMAGE_NAME} -q) 2>/dev/null || true