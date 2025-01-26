# Variables de configuración
COMPOSE_FILE = srcs/docker-compose.yml

# Target principal
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

# Construir y levantar contenedores
up:
	@echo "🚀 Levantando servicios con Docker Compose..."
	docker compose -f $(COMPOSE_FILE) up -d --build

# Detener contenedores
down:
	@echo "🛑 Deteniendo servicios..."
	docker compose -f $(COMPOSE_FILE) down

# Limpiar todo
clean: down
	@echo "🧹 Limpiando volúmenes y redes..."
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -af

# Reconstruir todo
re: clean all

# Mostrar logs
logs:
	docker compose -f $(COMPOSE_FILE) logs -f

# Acceder a contenedores
mariadb-bash:
	docker compose -f $(COMPOSE_FILE) exec mariadb bash

#show tables in mariadb
mariadb-show-tables:
	docker compose -f $(COMPOSE_FILE) exec mariadb mysql -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) $(MYSQL_DATABASE) -e "SHOW TABLES;"

mariadb-show-databases:
	docker compose -f $(COMPOSE_FILE) exec mariadb mysql -u $(MYSQL_USER) -p$(MYSQL_PASSWORD) -e "SHOW DATABASES;"

nginx-bash:
	docker compose -f $(COMPOSE_FILE) exec nginx sh


.PHONY: all up down clean re logs mariadb-bash nginx-bash
