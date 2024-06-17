.SILENT:
.PHONY: build clean test commit release help

# Variables
DIST_DIR := dist
SRC_FILE := src/main.sh
DIST_FILE := $(DIST_DIR)/csenv
TAR_FILE := $(DIST_DIR)/csenv_$(VERSION).tar.gz
SHA_FILE := $(TAR_FILE).sha256

# Help target to list available targets
help:
	@echo "Available targets:"
	@echo "  build:    Build the source file"
	@echo "  clean:    Clean up build artifacts"
	@echo "  test:     Test homebrew installation"
	@echo "  commit:   Commit changes to the repository"
	@echo "  release:  Create a new GitHub release"
	@echo "  help:     Display this help message"
	@echo ""
	@echo "Release usage:"
	@echo "  make release VERSION=<version> [FORCE=true]"

# Build target
build:
	@echo "Starting build process..."

	# Check if VERSION is set
	if [ -z "$(VERSION)" ]; then \
		echo "VERSION is not set. Please provide a version (e.g., make build VERSION=1.0.0)"; \
		echo "Latest version: `gh release view | grep "Release"`"; \
		exit 1; \
	fi

	rm -rf $(DIST_DIR)
	mkdir -p $(DIST_DIR)
	install -m 0755 $(SRC_FILE) $(DIST_FILE)
	tar -czvf $(TAR_FILE) -C $(DIST_DIR) csenv
	@echo "Build complete"
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
	brew tap appleboiy/tap
	brew install appleboiy/tap/csenv
	@echo "Test complete"

# Commit target to commit changes to the repository
commit:
	@echo "Committing changes..."
	git add .
	git commit -m "Build and release version $(VERSION)"
	git push
	@echo "Changes committed"

# Release target to create a new GitHub release
release: build commit
	@echo "Creating release $(VERSION)..."
	if [ -z "$(VERSION)" ]; then \
		echo "VERSION is not set. Please provide a version (e.g., make release VERSION=1.0.0)"; \
		exit 1; \
	fi
	echo "Release $(VERSION)" > $(DIST_DIR)/release_notes.md
	echo "" >> $(DIST_DIR)/release_notes.md
	echo "File: csenv_$(VERSION).tar.gz" >> $(DIST_DIR)/release_notes.md
	echo "SHA256: `cat $(SHA_FILE)`" >> $(DIST_DIR)/release_notes.md
	if [ "$(FORCE)" = "true" ]; then \
		gh release create $(VERSION) $(TAR_FILE) -F $(DIST_DIR)/release_notes.md || \
		(gh release delete $(VERSION) -y && gh release create $(VERSION) $(TAR_FILE) -F $(DIST_DIR)/release_notes.md); \
	else \
		gh release create $(VERSION) $(TAR_FILE) -F $(DIST_DIR)/release_notes.md; \
	fi
	@echo "Release $(VERSION) created"
	gh release view

