include srcs/.env

MKDIR			= mkdir -p
RM			= rm -rf
COMPOSE			= docker compose -f

COMPOSE_FILE		= ./srcs/docker-compose.yml
VOLUMES_HOST_BINDS	= $(VOLUMES_HOME)/nginx_conf

all: up

up: volumes_folders
	$(COMPOSE) $(COMPOSE_FILE) up -d --build
down:
	$(COMPOSE) $(COMPOSE_FILE) down 
start:
	$(COMPOSE) $(COMPOSE_FILE) start
stop:
	$(COMPOSE) $(COMPOSE_FILE) stop
volumes_folders:
	$(MKDIR) $(VOLUMES_HOST_BINDS)
clean: down

fclean:
	$(COMPOSE) $(COMPOSE_FILE) down -v --rmi all

re: fclean all

.PHONY: all up down clean fclean re
