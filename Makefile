COMPOSE_FILE = srcs/docker-compose.yml

all: up

nginx:
	docker compose -f $(COMPOSE_FILE) up -d --build nginx
#	docker-compose -f $(COMPOSE_FILE) --project-name inception up -d --build nginx

mariadb:
	docker compose -f $(COMPOSE_FILE) up -d --build mariadb

wordpress:
	docker compose -f $(COMPOSE_FILE) up -d --build wordpress

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

nginx-logs:
	docker compose -f $(COMPOSE_FILE) logs -f nginx

mariadb-logs:
	docker compose -f $(COMPOSE_FILE) logs -f mariadb

wordpress-logs:
	docker compose -f $(COMPOSE_FILE) logs -f wordpress

up:
	@echo "🚀 Upping services with Docker Compose..."
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	@echo "🛑 Stopping services..."
	docker compose -f $(COMPOSE_FILE) down

clean: down
	@echo "🧹 Cleaning volumes and networks..."
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af

re: clean all

logs:
	docker compose -f $(COMPOSE_FILE) logs -f


# Access to containers
mariadb-bash:
	docker compose -f $(COMPOSE_FILE) exec mariadb bash

nginx-bash:
	docker compose -f $(COMPOSE_FILE) exec nginx sh

wordpress-bash:
	docker compose -f $(COMPOSE_FILE) exec wordpress bash

#show tables in mariadb
mariadb-show-tables:
	docker compose -f $(COMPOSE_FILE) exec mariadb mysql -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) -e "SHOW TABLES;"

mariadb-show-databases:
	docker compose -f $(COMPOSE_FILE) exec mariadb mysql -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) -e "SHOW DATABASES;"



.PHONY: all up down clean re logs mariadb-bash nginx-bash wordpress-bash
