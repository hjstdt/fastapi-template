.PHONY: upgrade install lint format typecheck test run ulean check

upgrade:
	@echo "upgrading all tools..."
	uv self update
	pre-commit autoupdate
	uv sync --upgrade
	@echo "✓ everything updated!"

install:
	uv sync
	uv run pre-commit install

format:
	uv run ruff format .

lint:
	uv run ruff check .

typecheck:
	uv run pyright

test:
	uv run pytest

run:
	uv run src/main.py

clean:
	find . -type d -name __pycache__ -exec rm -rf {} + 
	rm -rf .venv .pytest_cache .ruff_cache

check: lint typecheck test
	@echo "✓ all checks passed!"
