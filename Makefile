# read configuration
ifneq (,$(wildcard .env))
    include .env
    export
endif

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:' Makefile | grep -v '\.PHONY' | cut -d: -f1 

.PHONY: update
update:
	uv self update
	uv run pre-commit autoupdate
	uv sync --upgrade

.PHONY: install
install: update
	uv sync
	uv run pre-commit install

.PHONY: lockfile
lockfile:
	uv lock --check

.PHONY: lint
lint:
	uv run ruff check

.PHONY: format
format:
	uv run ruff format

.PHONY: typecheck
typecheck:
	uv run mypy

.PHONY: test
test:
	uv run pytest --cov src/

.PHONY: check
check: lockfile lint format typecheck test
	@echo "✓ all checks passed!"

.PHONY: pre-commit
pre-commit:
	uv run pre-commit run --all-files

.PHONY:
dev: check
	uv run uvicorn src.fastapi_test.app:app --host $(HOST) --port $(PORT) --reload

.PHONY: run
run: check
	uv run uvicorn src.fastapi_test.app:app --host $(HOST) --port $(PORT)

.PHONY: docker-build
docker-build: check
	docker build . -t ${IMAGE_NAME}

.PHONY: docker_run
docker-run: docker-build
	docker run -p ${HOST}:${PORT}:${PORT} --env-file .env ${IMAGE_NAME}

.PHONY: clean
clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 
	rm -rf .venv .pytest_cache .ruff_cache .mypy_cache .coverage dist
	docker image rm -f $$(docker images ${IMAGE_NAME} -q) 2>/dev/null || true