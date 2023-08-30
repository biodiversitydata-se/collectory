run:
	docker compose up --detach mysqldb
	./gradlew bootRun

# You need to change dataSource.url in collectory-config.properties
# to use 'mysqldb' instead of '127.0.0.1' for this to work
run-docker:
	./gradlew build
	docker compose up --detach

release:
	@./sbdi/make-release.sh
