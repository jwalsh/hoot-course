# Directories
SUBDIRS = src tests examples scripts web

# Documentation
dist_doc_DATA = README.org

# Variables for commands and options
SCHEME = guile
SCHEME_FLAGS = 
SRC_DIR = src
TEST_DIR = tests
EXAMPLE_DIR = examples
BUILD_DIR = build
DOC_DIR = doc

# Scheme files
SCHEME_SRCS = $(wildcard $(SRC_DIR)/*.scm)
SCHEME_OBJS = $(patsubst $(SRC_DIR)/%.scm, $(BUILD_DIR)/%.o, $(SCHEME_SRCS))

# Default target
all: setup build test

# Setup target
setup:
	./scripts/setup.sh

# Build target
build: $(SCHEME_OBJS)
	@echo "Build complete"

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.scm
	$(SCHEME) $(SCHEME_FLAGS) -c $< -o $@

# Run tests
test:
	./scripts/run_tests.sh

# Clean target
clean:
	rm -rf $(BUILD_DIR) *.log

# Install documentation
install-doc: $(dist_doc_DATA)
	@echo "Installing documentation..."
	@install -d $(DESTDIR)/$(DOC_DIR)
	@install -m 644 $^ $(DESTDIR)/$(DOC_DIR)

.PHONY: all clean test install-doc setup build

# Include subdirectories' makefiles if needed
# include $(foreach dir, $(SUBDIRS), $(dir)/Makefile)
