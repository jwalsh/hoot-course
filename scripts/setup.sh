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
    brew unlink guile || true
    brew install guile-hoot
}

setup_project_structure() {
    echo "Setting up project structure..."
    mkdir -p src build web
    for file in reflect.js reflect.wasm wtf8.wasm; do
        if [ ! -f "web/$file" ]; then
            cp "reflect-${file%.*}/$file" web/
        fi
    done
    echo "Project structure check complete."
}

install_guile_packages() {
    echo "Checking and installing required Guile packages..."
    guile -c '
    (use-modules (ice-9 popen) (ice-9 rdelim))
    (let* ((cmd "guile -c \"(display (find-module-path (quote (srfi srfi-64))))\"")
           (port (open-input-pipe cmd))
           (path (read-line port)))
      (close-pipe port)
      (if (string-null? path)
          (begin
            (display "Installing SRFI-64...\n")
            (system "guile -c \"(use-modules (guix packages)) (guix-install (quote srfi-64))\""))
          (display "SRFI-64 already installed.\n")))'
}

main() {
    echo "Setting up project dependencies..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS detected"
        check_command hoot || install_hoot_macos
    else
        echo "Non-macOS system detected"
        echo "Please ensure Hoot is installed: https://spritely.institute/hoot/"
        check_command hoot || { echo "Hoot is not installed or not in PATH"; exit 1; }
    fi

    check_command guile || { echo "Guile is not installed. Please install Guile and try again."; exit 1; }

    setup_project_structure
    install_guile_packages

    echo "Setup complete. You can now build the examples using 'make all'"
}

main
