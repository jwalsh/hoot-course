#!/bin/bash
echo "Linting Bash scripts..."
shellcheck scripts/*.sh
shfmt -d -i 2 scripts/*.sh

echo "Linting Scheme files..."
guile-lint src/*.scm tests/*.scm examples/*.scm
