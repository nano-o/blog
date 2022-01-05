#
# Author: Jake Zimmerman <jake@zimmerman.io>
#
# ===== Usage ================================================================
#
# make                  Prepare blog/ folder (all markdown & assets)
# make blog/index.html  Recompile just blog/index.html
#
# make watch            Start a local HTTP server and rebuild on changes
# PORT=4242 make watch  Like above, but use port 4242
#
# make clean            Delete all generated files
#
# ============================================================================

# LICENSE: https://blueoakcouncil.org/license/1.0.0

SOURCES := $(shell find src -type f -name '*.md')
TARGETS := $(patsubst src/%.md,blog/%.html,$(SOURCES))

.PHONY: all
all: blog/.nojekyll $(TARGETS)

.PHONY: clean
clean:
	rm -rf blog

.PHONY: watch
watch:
	./tools/serve.sh --watch

blog/.nojekyll: $(wildcard public/*) public/.nojekyll
	rm -vrf blog && mkdir -p blog && cp -vr public/.nojekyll public/* blog

.PHONY: blog
blog: blog/.nojekyll

# Generalized rule: how to build a .html file from each .md
# Note: you will need pandoc 2 or greater for this to work
blog/%.html: src/%.md template.html5 Makefile tools/build.sh
	tools/build.sh "$<" "$@"


