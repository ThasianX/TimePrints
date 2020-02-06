OUTPUT_PATH = build
PROJ_PATH = $(IOS_OUTPUT_PATH)/mbgl.xcodeproj
CARTHAGE_PATH = Carthage

.PHONY: name-header
name-header:
	./scripts/package.sh -h

.PHONY: get-current-version
get-current-version:
	./scripts/package.sh -v

.PHONY: tag-version
tag-version:
	./scripts/package.sh -t $(VERSION)

.PHONY: create-static
create-static:
	./scripts/package.sh -s

.PHONY: clean-carthage
clean-carthage:
	rm -fr $(CARTHAGE_PATH)/*

.PHONY: clean
clean: clean-carthage
	rm -fr $(OUTPUT_PATH)

.PHONY: pod-lint
pod-lint:
	pod lib lint

.PHONE: preflight-checks
preflight-checks: pod-lint

DOCS_DIR := docs
DOCS_INDEX = $(DOCS_DIR)/index.html
DOCS_README = readme.md
DOCS_LICENSE = LICENSE.md
LOWDOWN_PATH = $(shell which lowdown)
MARKDOWN_PATH = $(shell which multimarkdown)

ifneq ($(LOWDOWN_PATH),)
	MARKDOWN_TOOL = $(LOWDOWN_PATH)
	MARKDOWN_ARGS = "-so"
else ifneq ($(MARKDOWN_PATH),)
	MARKDOWN_TOOL = $(MARKDOWN_PATH)
	MARKDOWN_ARGS = "-s"
endif

.PHONY: headerdoc
headerdoc:
	find MapboxMobileEvents -type f -name '*.h' | xargs headerdoc2html -o $(DOCS_DIR)
	gatherheaderdoc $(DOCS_DIR)

.PHONY: docindex
docindex:
	echo "<html><head><title>MapboxMobileEvents</title><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><body>" > $(DOCS_INDEX)
	$(MARKDOWN_TOOL) $(MARKDOWN_ARGS) $(DOCS_README) >> $(DOCS_INDEX)
	echo "<h2>License</h2><tt>" >> $(DOCS_INDEX)
	$(MARKDOWN_TOOL) $(MARKDOWN_ARGS) $(DOCS_LICENSE) >> $(DOCS_INDEX)
	echo "</tt></body></html>" >> $(DOCS_INDEX)

.PHONY: docs
docs: $(DOCS_DIR) headerdoc docindex
	open $(DOCS_INDEX)
