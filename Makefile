# include srcs/.env

MKDIR		= mkdir -p
RM			= rm -rf
COMPOSE	= docker compose -f

COMPOSE_FILE		= ./srcs/docker-compose.yml

DATA_DIR = $(HOME)/data
DATA_SUBDIRS = inception mariadb nginx

all: up ## Same as up (default target)

up: data_dirs certs ## Build and start containers, after creating data dirs and certs
	$(COMPOSE) $(COMPOSE_FILE) up -d --build --remove-orphans

down: ## Stop and remove containers
	$(COMPOSE) $(COMPOSE_FILE) down --remove-orphans

start: ## Start existing containers
	$(COMPOSE) $(COMPOSE_FILE) start

stop: ## Stop running containers
	$(COMPOSE) $(COMPOSE_FILE) stop

logs: ## Follow container logs
	$(COMPOSE) $(COMPOSE_FILE) logs -f
ps: ## Show container status
	$(COMPOSE) $(COMPOSE_FILE) ps

restart: stop start ## Restart all containers

clean: down ## Same as down

fclean: ## Stop and remove containers, volumes and images
	$(COMPOSE) $(COMPOSE_FILE) down -v --rmi local

re: fclean all ## fclean + all (full rebuild)

data_dirs: ## Create host directories for persistent data
	$(MKDIR) $(foreach d,$(DATA_SUBDIRS),$(DATA_DIR)/$(d))

certs: .certs-stamp ## Generate TLS certificates

.certs-stamp: make_certs.sh
	@chmod +x make_certs.sh && \
	./make_certs.sh && \
	touch $@

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

.PHONY: all up down clean fclean re certs data_dir start stop
