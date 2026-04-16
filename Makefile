.PHONY: up down restart mysql sql logs ps

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

mysql:
	docker exec -it mysql_container mysql -u root -ppassword mydatabase

sql:
	docker exec -i mysql_container mysql -u root -ppassword mydatabase < $(FILE)

logs:
	docker compose logs -f mysql

ps:
	docker compose ps
