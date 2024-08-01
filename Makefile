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

HOOT = hoot
GUILE = guile

.PHONY: all hello-world todo-app clean

all: hello-world todo-app

hello-world: src/hello-world.scm
	$(HOOT) compile -o build/hello-world.wasm src/hello-world.scm
	cp build/hello-world.wasm web/

todo-app: src/todo-app.scm
	$(HOOT) compile -o build/todo-app.wasm src/todo-app.scm
	cp build/todo-app.wasm web/

run-hello-world: hello-world
	$(GUILE) -e "(load-extension \"build/hello-world.wasm\")"

clean:
	rm -f build/*.wasm web/*.wasm
