# Inception Project Documentation

## Overview
This project implements a complete web infrastructure using Docker containers. It consists of three main services: NGINX (web server), WordPress (CMS), and MariaDB (database), all containerized and working together in a secure environment.

## Architecture

### Services
1. **NGINX**
   - Serves as reverse proxy
   - Handles SSL/TLS termination
   - Listens on port 443 (HTTPS)
   - Custom configuration for WordPress handling

2. **WordPress**
   - PHP-FPM based installation
   - Custom configuration with wp-config.php
   - Runs on port 9000
   - Secure file permissions

3. **MariaDB**
   - Database server
   - Custom initialization script
   - Runs on port 3306
   - Secure user management

## Docker Configuration

### Docker Compose
The services are orchestrated using Docker Compose, defined in `docker-compose.yml`. Key features:
- Network isolation using custom bridge network
- Volume management for persistent data
- Environment variable support
- Automatic container restart

### Volumes
Three persistent volumes are configured:
- `nginx_data_certs`: SSL certificates
- `mariadb_data`: Database files
- `wordpress_data`: WordPress files

## Security Features

1. **SSL/TLS Configuration**
- Self-signed certificates
- TLS 1.2/1.3 support
- Secure key generation

2. **Database Security**
- Custom user creation
- Password protection
- Limited privilege assignments
- Network isolation

3. **WordPress Security**
- Custom PHP-FPM configuration
- Secure file permissions
- Debug mode configuration
- SSL forced for admin

## Build and Deployment

### Makefile Commands
The project includes a comprehensive Makefile with the following main targets:
- `make up`: Start all services
- `make down`: Stop all services
- `make clean`: Clean all containers and volumes
- `make re`: Rebuild everything
- `make logs`: View service logs

### Environment Variables
Required environment variables (stored in `.env` file):
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `DOMAIN_NAME`

## Monitoring and Maintenance

### Logging
- NGINX access and error logs
- MariaDB logs
- WordPress debug logs
- All logs accessible via Docker commands

### Database Management
Special commands available for database administration:
- `make mariadb-bash`: Access MariaDB shell
- `make mariadb-show-tables`: Display database tables
- `make mariadb-show-databases`: List all databases

## Development Setup

### Prerequisites
- Docker
- Docker Compose
- Make utility

### Quick Start
1. Clone the repository
2. Create `.env` file with required variables
3. Run `make up`
4. Access WordPress at `https://[DOMAIN_NAME]`

## Best Practices Implemented
1. Container isolation
2. Environment variable usage
3. Volume persistence
4. Secure communications
5. Automated deployment
6. Comprehensive logging
7. Easy maintenance commands

## Troubleshooting
- Use `make logs` to view service logs
- Access containers with `make mariadb-bash` or `make nginx-bash`
- Check database connectivity with provided database commands
- Verify SSL certificates in NGINX container

For detailed implementation specifics, refer to the individual configuration files and Dockerfiles in the repository.
