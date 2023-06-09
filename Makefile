PHONY: setup

setup:
	docker compose build
	docker compose run --rm development rake db:create db:migrate
	docker compose run --rm test rake db:create db:test:prepare

seed:
	docker compose run --rm development rake db:seed
