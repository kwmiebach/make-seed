SHELL := /bin/bash

include .env

COMPOSE_FILE := compose.yaml

.PHONY: default
default: help


## --------------------------------------------------------------------------------------------------


.PHONY: help
help: ## Show this help message
	@grep -hE '^(## |[a-zA-Z0-9_-]+:.*?## )' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "} /^## / {printf "\n\033[1m%s\033[0m\n", substr($$0,4)} /^[a-zA-Z0-9_-]+:/ {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'


## Build


.PHONY: build
build: ## Build the docker image
	@./bin/build.pl $(filter-out $@,$(MAKECMDGOALS))


## Stack management


.PHONY: up
up: ## Start containers in detached mode
	docker compose -f $(COMPOSE_FILE) up -d

.PHONY: upf
upf: ## Start containers in foreground
	docker compose -f $(COMPOSE_FILE) up

.PHONY: restart
restart: ## Restart containers
	docker compose -f $(COMPOSE_FILE) restart

.PHONY: re
re: restart ## (alias for restart)

.PHONY: down dn
down: ## Stop and remove containers
	docker compose -f $(COMPOSE_FILE) down
dn: down

.PHONY: downup
downup: ## Down + up (applies config changes)
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) up -d

.PHONY: dnup
dnup: downup ## (alias for downup)

.PHONY: downupf
downupf: ## Down + up in foreground
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) up

.PHONY: dnupf
dnupf: downupf ## (alias for downupf)


## Shell Access


.PHONY: it-a
it-a: ## Exec into service-a (bash shell)
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE_A) sh

.PHONY: it-b
it-b: ## Exec into service-b (bash shell)
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE_B) sh


## Logging and Status


.PHONY: log
log: ## Show all container logs
	docker compose -f $(COMPOSE_FILE) logs

.PHONY: logf
logf: ## Follow all container logs
	docker compose -f $(COMPOSE_FILE) logs -f

.PHONY: ps
ps: ## Show container status with resource usage
	@docker compose -f $(COMPOSE_FILE) ps -q | xargs -r docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.MemUsage}}" 2>/dev/null || docker compose -f $(COMPOSE_FILE) ps


## Deployment


.PHONY: deploy
deploy: ## Deploy to environment (usage: make deploy prod)
	@./bin/deploy.pl $(filter-out $@,$(MAKECMDGOALS))


## Utility


.PHONY: env-tpl
env-tpl: ## Create .env-tpl from .env (masks secrets)
	@./bin/env-tpl-create.sh

.PHONY: clean
clean: ## Clean build artifacts
	@./bin/clean.sh


# Catch-all pattern for extra arguments (prevents Make errors)
%:
	@:
