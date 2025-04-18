.PHONY: build up down bash console migrate rollback routes test seed

# Construir containers
build:
	docker-compose build

# Iniciar containers
up:
	docker-compose up

# Iniciar containers em modo detached
upd:
	docker-compose up -d

# Parar containers
down:
	docker-compose down

# Acessar o bash do container web
bash:
	docker-compose exec web bash

# Abrir o console Rails
console:
	docker-compose exec web rails console

# Executar migrações
migrate:
	docker-compose exec web rails db:migrate

# Reverter última migração
rollback:
	docker-compose exec web rails db:rollback

# Listar rotas
routes:
	docker-compose exec web rails routes

# Executar testes
test:
	docker-compose exec web rails test

# Executar seeds
seed:
	docker-compose exec web rails db:seed

# Criar novo projeto Rails (executar apenas na primeira vez)
new:
	docker-compose run --rm web bash -c "rails new . --force --api --database=postgresql --skip-git"
