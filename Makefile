# Variables de configuración
COMPOSE_FILE = srcs/docker-compose.yml

# Target principal
all: up

# Construir y levantar contenedores
up:
	@echo "🚀 Upping services with Docker Compose..."
	docker-compose -f $(COMPOSE_FILE) up -d --build

# Detener contenedores
down:
	@echo "🛑 Stopping services..."
	docker-compose -f $(COMPOSE_FILE) down

# Limpiar todo
clean: down
	@echo "🧹 Cleaning volumes and networks..."
	docker-compose -f $(COMPOSE_FILE) down -v
	docker system prune -af

# Reconstruir todo
re: clean all

# Mostrar logs
logs:
	docker-compose -f $(COMPOSE_FILE) logs -f

# Acceder a contenedores
mariadb-bash:
	docker-compose -f $(COMPOSE_FILE) exec mariadb bash

nginx-bash:
	docker-compose -f $(COMPOSE_FILE) exec nginx sh

wordpress-bash:
	docker-compose -f $(COMPOSE_FILE) exec wordpress bash

.PHONY: all up down clean re logs mariadb-bash nginx-bash wordpress-bash
