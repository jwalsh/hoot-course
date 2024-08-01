#!/bin/bash

set -e

check_command() {
    if ! command -v "$1" &> /dev/null; then
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

    # Copy necessary files only if they don't exist
    [ -f web/reflect.js ] || cp reflect-js/reflect.js web/
    [ -f web/reflect.wasm ] || cp reflect-wasm/reflect.wasm web/
    [ -f web/wtf8.wasm ] || cp reflect-wasm/wtf8.wasm web/

    echo "Project structure check complete."
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

    echo "Setup check complete. You can now build the examples using 'make all'"
}
