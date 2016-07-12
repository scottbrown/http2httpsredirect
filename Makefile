.DEFAULT_GOAL := all
.PHONY := all help deps image tag release start-server stop-server

DOCKER_BIN := docker
IMAGE_NAME := http2httpsredirect
NAMESPACE  := unbounce

all: help  ## [DEFAULT] Display help

help: ## Displays this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deps: ## Ensures required binaries and libs are installed
	@hash $(DOCKER_BIN) > /dev/null 2>&1 || \
		(echo "Install docker to continue."; exit 1)

image: deps ## Builds the docker image
	$(DOCKER_BIN) build --pull --force-rm --no-cache -t $(IMAGE_NAME) .

tag: deps ## Tags the docker image with a given version
ifndef VERSION
	@(echo "Provide a VERSION parameter to continue."; exit 1)
endif
	$(DOCKER_BIN) tag $(IMAGE_NAME) $(NAMESPACE)/$(IMAGE_NAME):$(VERSION)
	$(DOCKER_BIN) tag $(IMAGE_NAME) $(NAMESPACE)/$(IMAGE_NAME):latest

release: deps ## Pushes the versioned image to Docker Hub
ifndef VERSION
	@(echo "Provide a VERSION parameter to continue."; exit 1)
endif
	$(DOCKER_BIN) push $(NAMESPACE)/$(IMAGE_NAME):$(VERSION)
	$(DOCKER_BIN) push $(NAMESPACE)/$(IMAGE_NAME):latest

start-server: deps
	$(DOCKER_BIN) run \
		--detach \
		--publish 8000:80 \
		--name=http2httpsredirect http2httpsredirect

stop-server: deps
	$(DOCKER_BIN) stop http2httpsredirect
	$(DOCKER_BIN) rm http2httpsredirect
