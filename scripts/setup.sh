#!/bin/bash

set -e

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 could not be found"
        return 1
    fi
}

install_hoot_macos() {
    echo "Installing Hoot on macOS..."

    if ! check_command brew; then
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi

    brew tap aconchillo/guile
    brew unlink guile || true  # Ignore if guile is not installed
    brew install guile-hoot
}

setup_project_structure() {
    echo "Setting up project structure..."
    mkdir -p src build web

    # Copy necessary files
    cp reflect-js/reflect.js web/
    cp reflect-wasm/reflect.wasm web/
    cp reflect-wasm/wtf8.wasm web/

    echo "Project structure set up complete."
}

create_example_files() {
    echo "Creating example Scheme files..."

    # Hello World example
    cat > src/hello-world.scm << EOL
(define-module (hello-world)
  #:export (main))

(define (main)
  (display "Hello, WebAssembly World!")
  (newline))
EOL

    # Todo App example (basic structure)
    cat > src/todo-app.scm << EOL
(define-module (todo-app)
  #:export (main add-todo remove-todo list-todos))

(define todos '())

(define (add-todo task)
  (set! todos (cons task todos)))

(define (remove-todo index)
  (set! todos (list-delete todos index)))

(define (list-todos)
  (map (lambda (todo index)
         (format #f "~a. ~a" (+ index 1) todo))
       todos
       (iota (length todos))))

(define (main)
  (display "Todo App initialized")
  (newline))
EOL

    echo "Example files created."
}

create_makefile() {
    echo "Creating Makefile..."

    cat > Makefile << EOL
HOOT = hoot
GUILE = guile

.PHONY: all hello-world todo-app clean

all: hello-world todo-app

hello-world: src/hello-world.scm
	\$(HOOT) compile -o build/hello-world.wasm src/hello-world.scm
	cp build/hello-world.wasm web/

todo-app: src/todo-app.scm
	\$(HOOT) compile -o build/todo-app.wasm src/todo-app.scm
	cp build/todo-app.wasm web/

run-hello-world: hello-world
	\$(GUILE) -e "(load-extension \"build/hello-world.wasm\")"

clean:
	rm -f build/*.wasm web/*.wasm
EOL

    echo "Makefile created."
}

create_html_file() {
    echo "Creating index.html..."

    cat > web/index.html << EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hoot Examples</title>
    <script src="reflect.js"></script>
</head>
<body>
    <h1>Hoot Examples</h1>
    <div id="output"></div>
    <script>
        async function runHelloWorld() {
            const { Scheme } = await import('./reflect.js');
            await Scheme.load_main("hello-world.wasm");
        }

        async function runTodoApp() {
            const { Scheme } = await import('./reflect.js');
            await Scheme.load_main("todo-app.wasm");
        }

        runHelloWorld().then(() => console.log("Hello World app loaded"));
        runTodoApp().then(() => console.log("Todo app loaded"));
    </script>
</body>
</html>
EOL

    echo "index.html created."
}

main() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS detected"
        if ! check_command hoot; then
            install_hoot_macos
        else
            echo "Hoot is already installed"
        fi
    else
        echo "Non-macOS system detected"
        echo "Please ensure Hoot is installed: https://spritely.institute/hoot/"

        if ! check_command hoot; then
            echo "Hoot is not installed or not in PATH"
            exit 1
        fi
    fi

    setup_project_structure
    create_example_files
    create_makefile
    create_html_file

    echo "Setup complete. You can now build the examples using 'make all'"
}

main
