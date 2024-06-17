.SILENT:
.PHONY: build clean test release

# Variables
VERSION := 0.0.2a
DIST_DIR := dist
SRC_FILE := src/main.sh
DIST_FILE := $(DIST_DIR)/csenv
TAR_FILE := $(DIST_DIR)/csenv_$(VERSION).tar.gz
SHA_FILE := $(TAR_FILE).sha256

# Build target
build:
	@echo "Starting build process..."
	# Clean up previous build artifacts
	rm -rf $(DIST_DIR)
	# Create necessary directories
	mkdir -p $(DIST_DIR)
	# Copy and prepare the source file
	chmod +x $(SRC_FILE)
	cp $(SRC_FILE) $(DIST_FILE)
	# Create a compressed tarball
	tar -czvf $(TAR_FILE) $(DIST_FILE)
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

# Test target for homebrew
test:
	@echo "Testing homebrew installation..."
	brew uninstall csenv || true
	brew untap appleboiy/tap || true
	brew cleanup
	brew tap appleboiy/tap
	brew install appleboiy/tap/csenv
	@echo "Test complete"

# Release target to create a new GitHub release
release: build
	@echo "Creating release $(VERSION)..."
	# Create a new release notes
	echo "Release $(VERSION)" > $(DIST_DIR)/release_notes.md
	echo "" >> $(DIST_DIR)/release_notes.md
	# tar file without path
	echo "File: csenv_$(VERSION).tar.gz" >> $(DIST_DIR)/release_notes.md
	echo "SHA256: `cat $(SHA_FILE)`" >> $(DIST_DIR)/release_notes.md
	
	# Create a new release
	@echo "Uploading..."
	gh release create $(VERSION) $(TAR_FILE) -F $(DIST_DIR)/release_notes.md || \
	(gh release delete $(VERSION) -y && gh release create $(VERSION) $(TAR_FILE) -F $(DIST_DIR)/release_notes.md)
	
	@echo "Release $(VERSION) created"
