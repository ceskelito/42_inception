MKDIR                = mkdir -p
COMPOSE_FILE         = srcs/docker-compose.yml
VOLUMES_HOST_BINDS   = /home/rceschel/data/nginx_conf

all: compose

compose: volumes_folders
	docker compose -f $(COMPOSE_FILE) up --build -d

volumes_folders:
	$(MKDIR) $(VOLUMES_HOST_BINDS)

clean:
	docker compose -f $(COMPOSE_FILE) down

fclean: clean
	docker compose -f $(COMPOSE_FILE) down -v --rmi all
	rm -rf $(VOLUMES_HOST_BINDS)

re: fclean all

.PHONY: all compose volumes_folders clean fclean re
