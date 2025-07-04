#!make

SHELL := /bin/bash

# Docker hub repository
REPO=mast3rm1lk/adminer-autologin
ADMINER_VERSION=5.3.0
ADMINER_FLAVOUR=
TAG=$(ADMINER_VERSION)$(ADMINER_FLAVOUR)
export

# output colors
C_BLACK=\e[0;30m
C_RED=\e[0;31m
C_GREEN=\e[0;32m
C_YELLOW=\e[0;33m
C_BLUE=\e[0;34m
C_PURPLE=\e[0;35m
C_CYAN=\e[0;36m
C_WHITE=\e[0;37m
C_GRAY=\e[0;90m
C_NONE=\e[0m

# Config
config_vars = \
	PWD \
	REPO \
	ADMINER_VERSION \
	ADMINER_FLAVOUR \
	TAG

# set binary
docker-compose = docker compose -f test/compose.yml -p adminer-autologin

# default target
.DEFAULT_GOAL := help

##@ General
.PHONY: help
help: ## ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\n${PROJECT_NAME} ${C_GREEN}${APP_RELEASE}${C_NONE}\n\nUsage:\n  make ${C_BLUE}<target>${C_NONE}\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  ${C_GREEN}%-25s${C_NONE} %s\n", $$1, $$2 } /^##@/ { printf "\n${C_YELLOW}%s${C_NONE}\n", substr($$0, 5) } /^##\?/ { printf "  ${C_GRAY}%s${C_NONE}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Test
.PHONY: up
up: ## (Re-)Create and start containers.
	@$(docker-compose) up -d --remove-orphans $(container)
##? [container="{{ name }}"]	For only one container by it service name.

.PHONY: down
down: ## (Re-)Create and start containers.
	@$(docker-compose) down $(container) ${or ${CMD}, --volumes}

.PHONY: stop
stop: ## Stop containers.
	@$(docker-compose) stop $(container)
##? [container="{{ name }}"]	For only one container by it service name.

.PHONY: ip
ip: guard-container ## Show container IP.
	@docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $$($(docker-compose) ps -aq ${or ${container}, php})
##? [container="{{ name }}"]	Service name, php by default.

.PHONY: ips
ips: ## Show container IPs.
	@for CONTAINER in $$(docker container ls --filter name=$(PROJECT_NAME) | awk '{print $$NF}' | awk 'NR > 1'); do echo -e "${C_GREEN}$$CONTAINER${C_NONE}" $$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $$CONTAINER); done | column -t

##@ Deploy
.PHONY: deploy
deploy: deploy-build deploy-publish deploy-latest

.PHONY: deploy-build
deploy-build: ## Build docker image for DockerHub deployment.
	docker build \
		--build-arg ADMINER_VERSION=$(ADMINER_VERSION) \
		--build-arg ADMINER_FLAVOUR=$(ADMINER_FLAVOUR) \
		-t $(REPO):$(TAG) \
		src

.PHONY: deploy-publish
deploy-publish: ## Publish on DockerHub.
	docker push $(REPO):$(TAG)

.PHONY: deploy-latest
deploy-latest: ## Publish latest version on DockerHub.
	docker tag $(REPO):$(TAG) $(REPO):latest
	docker push $(REPO):latest

##@ Configuration
.PHONY: config
config: ## Print list of configuration variables.
	@for var in $(config_vars); do \
		echo "$$var=$${!var}"; \
	done

.PHONY: config-get
config-get: guard-VAR ## Print one configuration variable.
	@echo ${if ${VAR}, "$$VAR=$${!VAR}", '"var" arg is required'}
##? [VAR="{{ name }}"]		Required environment variable name.

#### Utils
guard-%:
	@#$(or ${$*}, $(error $* is not set))