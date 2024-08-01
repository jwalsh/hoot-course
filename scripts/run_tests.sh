#!/bin/bash
echo "Running test suite..."
# Add commands to run tests
for t in tests/test-*.scm; do
    echo "Running test $t"
    # Get the associated Scheme file for the test 
    # and run it with
    SCM_FILE=$(echo $t | sed 's/tests\///' | sed 's/test-//' | sed 's/.scm//')
    echo "Running $SCM_FILE test $t"
    guile --no-auto-compile -l examples/$SCM_FILE.scm $t
done
