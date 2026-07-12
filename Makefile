# Common Pharo project tasks (macOS / Linux — Windows users: see docs/development.md).
# Reusable in other Pharo projects: adjust TEST_PATTERN (and PHARO_DIR if needed).

PHARO_DIR     = pharo-local
PHARO         = ./pharo --headless Pharo.image
TEST_PATTERN  = AWS.*
PHARO_VERSION = 130

.PHONY: help setup load test ui

help:   ## Show available targets
	@grep -E '^[a-z]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-7s %s\n", $$1, $$2}'

setup:  ## Download a local Pharo image + VM into pharo-local/
	mkdir -p $(PHARO_DIR)
	cd $(PHARO_DIR) && curl -fsSL https://get.pharo.org/64/$(PHARO_VERSION)+vm | bash

load:   ## Load (or reload) the project into the Pharo image
	cd $(PHARO_DIR) && $(PHARO) eval --save "$$(cat ../scripts/load-project.st)"

test:   ## Run tests headless with JUnit XML output (see docs/development.md for scope)
	cd $(PHARO_DIR) && $(PHARO) test --junit-xml-output '$(TEST_PATTERN)'

ui:     ## Open the Pharo GUI
	cd $(PHARO_DIR) && ./pharo-ui Pharo.image
