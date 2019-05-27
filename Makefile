.DEFAULT_GOAL := all

DOCKER_BIN := sudo docker
IMAGE_NAME := http2httpsredirect
NAMESPACE  := scottbrown

.PHONY: all
all: help  ## [DEFAULT] Display help

.PHONY: help
help: ## Displays this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: deps
deps: ## Ensures required binaries and libs are installed
	@hash $(DOCKER_BIN) > /dev/null 2>&1 || \
		(echo "Install docker to continue."; exit 1)

.PHONY: image
image: deps ## Builds the docker image
	$(DOCKER_BIN) build --pull --force-rm --no-cache -t $(IMAGE_NAME) .

.PHONY: tag
tag: deps get-version ## Tags the docker image with a given version
	$(DOCKER_BIN) tag $(IMAGE_NAME) $(NAMESPACE)/$(IMAGE_NAME):$(VERSION)
	$(DOCKER_BIN) tag $(IMAGE_NAME) $(NAMESPACE)/$(IMAGE_NAME):latest

.PHONY: release
release: deps get-version ## Pushes the versioned image to Docker Hub
	$(DOCKER_BIN) push $(NAMESPACE)/$(IMAGE_NAME):$(VERSION)
	$(DOCKER_BIN) push $(NAMESPACE)/$(IMAGE_NAME):latest

.PHONY: start-server
start-server: deps
	$(DOCKER_BIN) run \
		--detach \
		--publish 8000:80 \
		--name=http2httpsredirect http2httpsredirect

.PHONY: stop-server
stop-server: deps
	$(DOCKER_BIN) stop http2httpsredirect
	$(DOCKER_BIN) rm http2httpsredirect

.PHONY: get-version
get-version:
ifndef VERSION
	@(echo "Provide a VERSION parameter to continue."; exit 1)
endif

