BOLD := \033[1m
RESET := \033[0m
GREEN := \033[1;32m

# -- Docker
DOCKER_UID           = $(shell id -u)
DOCKER_GID           = $(shell id -g)
DOCKER_USER          = $(DOCKER_UID):$(DOCKER_GID)

# ENV
include .env

# ==============================================================================
# RULES

default: h

build-amd: ## Build peertube-runner image for amd/intel
	docker buildx build \
          --build-arg DOCKER_USER=$(DOCKER_USER) \
          --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
          --build-arg PEERTUBE_RUNNER_VERSION=${PEERTUBE_RUNNER_VERSION} \
          --build-arg WHISPER_CTRANSLATE2_VERSION=${WHISPER_CTRANSLATE2_VERSION} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=${PEERTUBE_RUNNER_TRANSCRIPTION_MODEL} \
	  --target runner \
	  -t ${REGISTRY_NAME}peertube-runner-amd:latest .
.PHONY: build-amd

build-arm: ## Build peertube-runner image for arm
	docker buildx build \
	  --build-arg DOCKER_USER=$(DOCKER_USER) \
	  --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
	  --build-arg PEERTUBE_RUNNER_VERSION=${PEERTUBE_RUNNER_VERSION} \
	  --build-arg WHISPER_CTRANSLATE2_VERSION=${WHISPER_CTRANSLATE2_VERSION} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=${PEERTUBE_RUNNER_TRANSCRIPTION_MODEL} \
	  --target runner \
	  -t ${REGISTRY_NAME}peertube-runner-arm:latest \
	  -f Dockerfile-arm .
.PHONY: build-arm

build-rockchip: ## Build peertube-runner image with ffmpeg-rockchip
	docker buildx build \
          --build-arg DOCKER_USER=$(DOCKER_USER) \
          --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
          --build-arg PEERTUBE_RUNNER_VERSION=${PEERTUBE_RUNNER_VERSION} \
          --build-arg WHISPER_CTRANSLATE2_VERSION=${WHISPER_CTRANSLATE2_VERSION} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=${PEERTUBE_RUNNER_TRANSCRIPTION_MODEL} \
	  --target runner \
	  -t ${REGISTRY_NAME}peertube-runner-rockchip:latest \
	  -f Dockerfile-ffmpeg-rockchip .
.PHONY: build-rockchip

build-amd-ctranslate: ## Build peertube-runner image for amd with whisper-ctranslate2
	docker buildx build  \
          --build-arg DOCKER_USER=$(DOCKER_USER) \
          --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
          --build-arg PEERTUBE_RUNNER_VERSION=${PEERTUBE_RUNNER_VERSION} \
          --build-arg WHISPER_CTRANSLATE2_VERSION=${WHISPER_CTRANSLATE2_VERSION} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=${PEERTUBE_RUNNER_TRANSCRIPTION_MODEL} \
	  --target whisper_ctranslate2 \
	  -t ${REGISTRY_NAME}peertube-runner-amd:latest-ctranslate .
.PHONY: build-amd-ctranslate

build-arm-ctranslate: ## Build peertube-runner image for arm with whisper-ctranslate2
	docker buildx build  \
          --build-arg DOCKER_USER=$(DOCKER_USER) \
          --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
          --build-arg PEERTUBE_RUNNER_VERSION=${PEERTUBE_RUNNER_VERSION} \
          --build-arg WHISPER_CTRANSLATE2_VERSION=${WHISPER_CTRANSLATE2_VERSION} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH} \
          --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=${PEERTUBE_RUNNER_TRANSCRIPTION_MODEL} \
	  --target whisper_ctranslate2 \
	  -t ${REGISTRY_NAME}peertube-runner-arm:latest-ctranslate \
	  -f Dockerfile-arm .
.PHONY: build-arm-ctranslate

build-rockchip-ctranslate: ## Build peertube-runner image with ffmpeg-rockchip and whisper-ctranslate2
	docker buildx build  \
          --build-arg DOCKER_USER=$(DOCKER_USER) \
          --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
          --build-arg PEERTUBE_RUNNER_VERSION=${PEERTUBE_RUNNER_VERSION} \
          --build-arg WHISPER_CTRANSLATE2_VERSION=${WHISPER_CTRANSLATE2_VERSION} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH=${PEERTUBE_RUNNER_TRANSCRIPTION_ENGINE_PATH} \
	  --build-arg PEERTUBE_RUNNER_TRANSCRIPTION_MODEL=${PEERTUBE_RUNNER_TRANSCRIPTION_MODEL} \
	  --target whisper_ctranslate2 \
	  -t ${REGISTRY_NAME}peertube-runner-rockchip:latest-ctranslate \
	  -f Dockerfile-ffmpeg-rockchip .
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
