# LICENSE: https://blueoakcouncil.org/license/1.0.0


BLOG_SOURCES := $(shell find src/blog -type f -name '*.md')
BLOG_TARGETS := $(patsubst src/blog/%.md,www/blog/%.html,$(BLOG_SOURCES))

.PHONY: all
all: www css img $(BLOG_TARGETS) www/index.html

.PHONY: clean
clean:
	rm -rf www

.PHONY: watch
watch:
	./tools/serve.sh --watch

.PHONY: www
www:
	mkdir -p www/blog

www/index.html: src/index.md src/template.html5 Makefile footer.html
	pandoc \
		--from markdown+smart \
		--filter pandoc-sidenote \
		--to html5+smart \
		--template=src/template \
		--css="css/theme.css" \
		--css="css/skylighting-solarized-theme.css" \
		--output "www/index.html" \
		-A footer.html \
		"src/index.md"

.PHONY: css
css: www $(wildcard public/*)
	rsync -rup public/css www/

www/blog/%.html: src/blog/%.md src/blog/template.html5 Makefile footer.html
	pandoc \
		--katex \
		--from markdown+tex_math_single_backslash \
		--filter pandoc-sidenote \
		--to html5+smart \
		--template=src/blog/template \
		--css="../css/theme.css" \
		--css="../css/skylighting-solarized-theme.css" \
		--toc \
		-A footer.html \
		--output "$@" \
		"$<"

.PHONY: img
img: www src/img
	rsync -rup src/img www/
