PROJECT_NAME ?= todobackend
ORG_NAME ?= jmenga
REPO_NAME ?= todobackend

DEV_COMPOSE_FILE := docker/dev/docker-compose.yml
RELEASE_COMPOSE_FILE := docker/release/docker-compose.yml

DEV_PROJECT := $(PROJECT_NAME)_dev
RELEASE_PROJECT := $(PROJECT_NAME)_$(BUILD_ID)

.PHONY: test build release clean

test:
	echo "Test"
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up agent
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up test

build:
	echo "Build"
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up builder

release:
	echo "Release"
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) build
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) up agent
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) run --rm app manage.py collectstatic --noinput
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) run --rm app manage.py migrate --noinput
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) up test

clean:
	echo "Clean"
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) kill
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) rm -f
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) kill
	docker-compose -p $(RELEASE_PROJECT) -f $(RELEASE_COMPOSE_FILE) rm -f
