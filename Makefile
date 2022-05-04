.DEFAULT_GOAL := help
.PHONY : help

CYAN := "\e[0;36m"
NC := "\e[0m"
INFO := @bash -c 'printf $(CYAN); echo "$$1"; printf $(NC)' MESSAGE

# Remove annoying Docker advertise
DOCKER_SCAN_SUGGEST=false

# Help
help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@sed -n 's/^## HELP://p' Makefile


build:
	${INFO} "🚀 Building container..."
	DOCKER_CONTEXT=default docker build . -t stackhero-heroku-examples
	${INFO} "✅ Successfully build container!"

## HELP: run          : Run Docker container (Heroku oAuth)
run: build
	DOCKER_CONTEXT=default docker run \
		-it \
		-h stackhero-heroku-examples \
		-v $(PWD):/stackhero \
		stackhero-heroku-examples

## HELP: run-password : Run Docker container (Heroku password)
run-password: build
	DOCKER_CONTEXT=default docker run \
		-it \
		-h stackhero-heroku-examples \
		-v $(PWD):/stackhero \
		-e HEROKU_INTERACTIVE=true \
		stackhero-heroku-examples