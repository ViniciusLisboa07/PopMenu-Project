.PHONY: build up down bash console migrate rollback routes test seed

build:
	docker-compose build

up:
	docker-compose up

upd:
	docker-compose up -d

down:
	docker-compose down

bash:
	docker-compose exec --user=root web bash

console:
	docker-compose exec web rails console

migrate:
	docker-compose exec web rails db:migrate

rollback:
	docker-compose exec web rails db:rollback

routes:
	docker-compose exec web rails routes

test:
	docker-compose exec web rspec spec/

seed:
	docker-compose exec web rails db:seed

new:
	docker-compose run --rm web bash -c "rails new . --force --api --database=postgresql --skip-git"
