SHELL := /bin/bash
VERSION ?= latest

# The directory of this file
DIR := $(shell echo $(shell cd "$(shell  dirname "${BASH_SOURCE[0]}" )" && pwd ))

IMAGE_NAME ?= schutzwerk/ubertooth
CONTAINER_NAME ?= ubertooth

# Build the container
build: ## Build the image
	sudo docker build --rm -t $(IMAGE_NAME):$(VERSION) .

build-nc: ## Build the container without caching
	sudo docker build --rm --no-cache -t $(IMAGE_NAME) .

run: ## Run container
	mkfifo $(DIR)/shared_folder/pipe && \
	sudo docker run \
		--name $(CONTAINER_NAME) \
		--net=host \
		--privileged \
		-v /dev/bus/usb:/dev/bus/usb \
		-v $(DIR)/shared_folder/pipe:/root/shared_folder/pipe \
		$(IMAGE_NAME):$(VERSION)

stop: ## Stop a running container
	sudo docker stop $(CONTAINER_NAME) && \
        rm -f ./shared_folder/pipe

remove: ## Remove a (running) container
	rm -f $(DIR)/shared_folder/pipe && \
	sudo docker rm -f $(CONTAINER_NAME)

restart: ## Restart the container
	make remove; \
	make run

remove-image-force: ## Remove the latest image (forced)
	sudo docker rmi -f $(IMAGE_NAME):$(VERSION)

# This will output the help for each task
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help
