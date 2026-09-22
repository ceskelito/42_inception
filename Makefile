include srcs/.env

MKDIR				= mkdir -p
RM					= rm -rf
COMPOSE				= docker compose -f

COMPOSE_FILE		= ./srcs/docker-compose.yml
VOLUMES_HOST_BINDS	= $(VOLUMES_HOME)/nginx_conf

all: compose

compose: volumes_folders
	$(COMPOSE) $(COMPOSE_FILE) up --build -d

volumes_folders:
	$(MKDIR) $(VOLUMES_HOST_BINDS)

clean:
	$(COMPOSE) $(COMPOSE_FILE) down

fclean: clean
	$(COMPOSE) $(COMPOSE_FILE) down -v --rmi all
	#$(RM) $(VOLUMES_HOST_BINDS)

re: fclean all

.PHONY: all compose volumes_folders clean fclean re
