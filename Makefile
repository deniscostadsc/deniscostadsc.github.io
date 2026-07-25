.PHONY: run build

run: build
	@docker run --rm \
		--init \
		--volume "$PWD:/srv/jekyll" \
		--publish 4000:4000 \
		--publish 35729:35729 \
		jekyll-image

build:
	@docker build -t jekyll-image .