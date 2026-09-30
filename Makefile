# include srcs/.env

# MKDIR		= mkdir -p
RM			= rm -rf
COMPOSE	= docker compose -f

COMPOSE_FILE		= ./srcs/docker-compose.yml

all: up

up: certs
	$(COMPOSE) $(COMPOSE_FILE) up -d --build

certs:
	@chmod +x ./srcs/requirements/nginx/tools/make_certs.sh && \
	./srcs/requirements/nginx/tools/make_certs.sh

down:
	$(COMPOSE) $(COMPOSE_FILE) down 
start:
	$(COMPOSE) $(COMPOSE_FILE) start
stop:
	$(COMPOSE) $(COMPOSE_FILE) stop

clean: down

fclean:
	$(COMPOSE) $(COMPOSE_FILE) down -v --rmi all

re: fclean all

.PHONY: all up down clean fclean re
