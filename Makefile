.SILENT:
.PHONY: build clean

# Variables
VERSION := 0.0.1
DIST_DIR := dist
SRC_FILE := src/main.sh
DIST_FILE := $(DIST_DIR)/main
TAR_FILE := $(DIST_DIR)/csenv_$(VERSION).tar.gz
SHA_FILE := $(TAR_FILE).sha256

# Build target
build:
	@echo "Starting build process..."
	rm -rf $(DIST_DIR)
	mkdir -p $(DIST_DIR)
	install -m 0755 $(SRC_FILE) $(DIST_FILE)
	# Create a compressed tarball of the dist directory
	tar -czvf $(TAR_FILE) -C $(DIST_DIR) main
	@echo "Build complete"
	# Generate SHA256 checksum
	shasum -a 256 $(TAR_FILE) | awk '{print $$1}' > $(SHA_FILE)
	@echo "SHA256: `cat $(SHA_FILE)`"
	@echo "PLEASE UPDATE THE SHA256 IN THE FORMULA FILE"

# Clean target to remove build artifacts
clean:
	@echo "Cleaning up..."
	rm -rf $(DIST_DIR)
	@echo "Clean complete"

test:
	brew uninstall csenv || true
	brew untap appleboiy/tap/csenv || true
	brew tap appleboiy/tap
	brew install appleboiy/tap/csenv