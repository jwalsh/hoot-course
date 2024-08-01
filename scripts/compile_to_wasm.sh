#!/bin/bash

# Hoot Build Script

set -e  # Exit on error

# Directory setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
SRC_DIR="$SCRIPT_DIR/src"
BUILD_DIR="$SCRIPT_DIR/build"
WEB_DIR="$SCRIPT_DIR/web"

# Create necessary directories
mkdir -p "$BUILD_DIR" "$WEB_DIR"

# Function to compile Scheme to WebAssembly
compile_to_wasm() {
    local input_file="$1"
    local output_file="$2"
    echo "Compiling $input_file to WebAssembly..."
    hoot compile -o "$output_file" "$input_file"
}

# Compile Scheme files to WebAssembly
compile_to_wasm "$SRC_DIR/hello-world.scm" "$BUILD_DIR/hello-world.wasm"
compile_to_wasm "$SRC_DIR/todo-app.scm" "$BUILD_DIR/todo-app.wasm"

# Copy necessary files for web setup
echo "Setting up web directory..."
cp "$BUILD_DIR"/*.wasm "$WEB_DIR/"
cp "$SCRIPT_DIR/reflect-js/reflect.js" "$WEB_DIR/"
cp "$SCRIPT_DIR/reflect-wasm/reflect.wasm" "$WEB_DIR/"
cp "$SCRIPT_DIR/reflect-wasm/wtf8.wasm" "$WEB_DIR/"

# Create a basic index.html for testing
cat > "$WEB_DIR/index.html" << EOL
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
        // Uncomment the next line when ready to test the todo app
        // runTodoApp().then(() => console.log("Todo app loaded"));
    </script>
</body>
</html>
EOL

echo "Build complete. WebAssembly files are in $BUILD_DIR"
echo "Web setup is complete. Files are in $WEB_DIR"
echo "You can now serve the $WEB_DIR directory with a web server to test the examples."
