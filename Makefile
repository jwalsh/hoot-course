.PHONY: all setup run test lint clean

all: setup

setup:
	@echo "Setting up the project..."
	@./scripts/setup.sh

run:
	@echo "Compiling and running example program..."
	@./scripts/run.sh

test:
	@echo "Running tests..."
	@./scripts/run_tests.sh

lint:
	@echo "Running linters..."
	@./scripts/lint.sh

clean:
	@echo "Cleaning up..."
	@rm -rf build
