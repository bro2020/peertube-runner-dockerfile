BOLD := \033[1m
RESET := \033[0m
GREEN := \033[1;32m

# -- Docker
DOCKER_UID           = $(shell id -u)
DOCKER_GID           = $(shell id -g)
DOCKER_USER          = $(DOCKER_UID):$(DOCKER_GID)

# ==============================================================================
# RULES

default: h

build-amd: ## Build peertube-runner image
	docker buildx build --build-arg DOCKER_USER=$(DOCKER_USER) --target runner -t peertube-runner-amd:latest .
.PHONY: build

build-rockchip: ## Build peertube-runner image with ffmpeg-rockchip
	docker buildx build --build-arg DOCKER_USER=$(DOCKER_USER) --target runner -t peertube-runner-rockchip:latest -f Dockerfile-ffmpeg-rockchip .
.PHONY: build-rockchip

build-amd-ctranslate: ## Build peertube-runner image with whisper-ctranslate2
	docker buildx build --build-arg DOCKER_USER=$(DOCKER_USER) --target whisper_ctranslate2 -t peertube-runner-amd:latest-ctranslate .
.PHONY: build-whisper_ctranslate2

build-rockchip-ctranslate: ## Build peertube-runner image with ffmpeg-rockchip and whisper-ctranslate2
	docker buildx build --build-arg DOCKER_USER=$(DOCKER_USER) --target whisper_ctranslate2 -t peertube-runner-rockchip:latest-ctranslate -f Dockerfile-ffmpeg-rockchip .
.PHONY: build-rockchip-ctranslate

h: # short default help task
	@echo "$(BOLD)Marsha Makefile$(RESET)"
	@echo "Please use 'make $(BOLD)target$(RESET)' where $(BOLD)target$(RESET) is one of:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-50s$(RESET) %s\n", $$1, $$2}'
.PHONY: h

help:  ## Show a more readable help on multiple lines
	@echo "$(BOLD)Marsha Makefile$(RESET)"
	@echo "Please use 'make $(BOLD)target$(RESET)' where $(BOLD)target$(RESET) is one of:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%s$(RESET)\n    %s\n\n", $$1, $$2}'
.PHONY: help
