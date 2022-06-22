#======================================================================
#
# example 'make init'
# example 'make package SKIP_TEST=true ENV=dev'
#
# author: chenlong
# date: 2020-09-27
#======================================================================

SHELL := /bin/bash -o pipefail

export BASE_PATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# ----------------------------- variables <-----------------------------
# unit test flag
SKIP_TEST ?= false
# env
ENV ?= local
# pom version default value is 'app.version'
NEW_VERSION := $(shell grep "app.version" $(BASE_PATH)/config/app.properties | cut -d'=' -f2 | sed 's/\ //' )
# ----------------------------- variables >-----------------------------

# ----------------------------- app.properties <-----------------------------
# app name
APPLICATION_NAME := $(shell grep "app.name" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //')
# jar name
APPLICATION_JAR := $(shell grep "app.name" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //')-boot-$(shell grep "app.version" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //').jar
# port
APPLICATION_PORT := $(shell grep "app.port" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //')
# docker.repository.name
DOCKER_REPOSITORY_NAME := $(shell grep "docker.repository.name" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //')
# docker image name
DOCKER_IMAGE_NAME := $(shell grep "docker.image.name" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //')
# docker image tag
DOCKER_IMAGE_TAG := $(shell grep "docker.image.tag" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //')
# docker container name
DOCKER_CONTAINER_NAME := $(shell grep "docker.container.name" $(BASE_PATH)/config/app.properties | cut -d'=' -f2| sed 's/\ //')
# ----------------------------- app.properties >-----------------------------

# ----------------------------- maven <-----------------------------
#
clean:
	$(BASE_PATH)/mvnw --batch-mode --errors -f ${BASE_PATH}/pom.xml clean

#
test:
	$(BASE_PATH)/mvnw --batch-mode --errors -f ${BASE_PATH}/pom.xml clean test -D test=*Test -DfailIfNoTests=false

#
package:
	@cat ${BASE_PATH}/deploy/deploy/debugger.sh | \
		sed 's/APPLICATION=[^<]*/APPLICATION=${APPLICATION_NAME}/1' | \
		sed 's/APPLICATION_JAR=[^<]*/APPLICATION_JAR=${APPLICATION_JAR}/1' \
		> ${BASE_PATH}/deploy/deploy/debugger.sh.newVersion && mv ${BASE_PATH}/deploy/deploy/debugger.sh.newVersion ${BASE_PATH}/deploy/deploy/debugger.sh
	@cat ${BASE_PATH}/deploy/deploy/startup.sh | \
		sed 's/APPLICATION=[^<]*/APPLICATION=${APPLICATION_NAME}/1' | \
		sed 's/APPLICATION_JAR=[^<]*/APPLICATION_JAR=${APPLICATION_JAR}/1' \
		> ${BASE_PATH}/deploy/deploy/startup.sh.newVersion && mv ${BASE_PATH}/deploy/deploy/startup.sh.newVersion ${BASE_PATH}/deploy/deploy/startup.sh
	@cat ${BASE_PATH}/deploy/deploy/shutdown.sh | \
		sed 's/APPLICATION=[^<]*/APPLICATION=${APPLICATION_NAME}/1' | \
		sed 's/APPLICATION_JAR=[^<]*/APPLICATION_JAR=${APPLICATION_JAR}/1' \
		> ${BASE_PATH}/deploy/deploy/shutdown.sh.newVersion && mv ${BASE_PATH}/deploy/deploy/shutdown.sh.newVersion ${BASE_PATH}/deploy/deploy/shutdown.sh
	@cat ${BASE_PATH}/deploy/deploy/restart.sh | \
		sed 's/APPLICATION=[^<]*/APPLICATION=${APPLICATION_NAME}/1' | \
		sed 's/APPLICATION_JAR=[^<]*/APPLICATION_JAR=${APPLICATION_JAR}/1' \
		> ${BASE_PATH}/deploy/deploy/restart.sh.newVersion && mv ${BASE_PATH}/deploy/deploy/restart.sh.newVersion ${BASE_PATH}/deploy/deploy/restart.sh
	$(BASE_PATH)/mvnw --batch-mode --errors --fail-at-end --update-snapshots -f ${BASE_PATH}/pom.xml clean package -P $(ENV) -D maven.test.skip=$(SKIP_TEST)

#
package.uncompress: package
	mkdir -p ${BASE_PATH}/target/app
	tar -zxvf ${BASE_PATH}/target/*.tar.gz -C ${BASE_PATH}/target/app --strip-components 1
#
set-version:
	sh ${BASE_PATH}/deploy/bin/set-version.sh $(NEW_VERSION)

#
install:
	$(BASE_PATH)/mvnw --batch-mode --errors --fail-at-end --update-snapshots -f ${BASE_PATH}/pom.xml clean install -P $(ENV) -D maven.test.skip=$(SKIP_TEST)

#
.PHONY: deploy
deploy:
	$(BASE_PATH)/mvnw --batch-mode --errors --fail-at-end --update-snapshots -f ${BASE_PATH}/pom.xml deploy
# ----------------------------- maven >-----------------------------

# ----------------------------- docker <-----------------------------
docker.init:
	@cat ${BASE_PATH}/deploy/bin/deployment/stop.sh | \
		sed 's#DOCKER_CONTAINER_NAME=[^<]*#DOCKER_CONTAINER_NAME=${DOCKER_CONTAINER_NAME}#1' | \
		sed 's#PROFILE=[^<]*#PROFILE=${ENV}#1' \
		> ${BASE_PATH}/deploy/bin/deployment/stop.sh.newVersion && \
		mv ${BASE_PATH}/deploy/bin/deployment/stop.sh.newVersion ${BASE_PATH}/deploy/bin/deployment/stop.sh
	@cat ${BASE_PATH}/deploy/bin/deployment/remove.sh | \
		sed 's#DOCKER_CONTAINER_NAME=[^<]*#DOCKER_CONTAINER_NAME=${DOCKER_CONTAINER_NAME}#1' | \
		sed 's#PROFILE=[^<]*#PROFILE=${ENV}#1' \
		> ${BASE_PATH}/deploy/bin/deployment/remove.sh.newVersion && \
		mv ${BASE_PATH}/deploy/bin/deployment/remove.sh.newVersion ${BASE_PATH}/deploy/bin/deployment/remove.sh
	@cat ${BASE_PATH}/deploy/bin/deployment/pull.sh | \
		sed 's#DOCKER_REPOSITORY_NAME=[^<]*#DOCKER_REPOSITORY_NAME=${DOCKER_REPOSITORY_NAME}#1' | \
		sed 's#DOCKER_IMAGE_NAME=[^<]*#DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}#1' | \
		sed 's#DOCKER_IMAGE_TAG=[^<]*#DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG}#1' | \
		sed 's#PROFILE=[^<]*#PROFILE=${ENV}#1' \
		> ${BASE_PATH}/deploy/bin/deployment/pull.sh.newVersion && \
		mv ${BASE_PATH}/deploy/bin/deployment/pull.sh.newVersion ${BASE_PATH}/deploy/bin/deployment/pull.sh
	@cat ${BASE_PATH}/deploy/bin/deployment/run.sh | \
		sed 's#DOCKER_REPOSITORY_NAME=[^<]*#DOCKER_REPOSITORY_NAME=${DOCKER_REPOSITORY_NAME}#1' | \
		sed 's#DOCKER_IMAGE_NAME=[^<]*#DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}#1' | \
		sed 's#DOCKER_IMAGE_TAG=[^<]*#DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG}#1' | \
		sed 's#DOCKER_CONTAINER_NAME=[^<]*#DOCKER_CONTAINER_NAME=${DOCKER_CONTAINER_NAME}#1' | \
		sed 's#APPLICATION_PORT=[^<]*#APPLICATION_PORT=${APPLICATION_PORT}#1' | \
		sed 's#PROFILE=[^<]*#PROFILE=${ENV}#1' \
		> ${BASE_PATH}/deploy/bin/deployment/run.sh.newVersion && \
		mv ${BASE_PATH}/deploy/bin/deployment/run.sh.newVersion ${BASE_PATH}/deploy/bin/deployment/run.sh
	@cat ${BASE_PATH}/deploy/bin/deployment/run-mapping.sh | \
		sed 's#DOCKER_REPOSITORY_NAME=[^<]*#DOCKER_REPOSITORY_NAME=${DOCKER_REPOSITORY_NAME}#1' | \
		sed 's#DOCKER_IMAGE_NAME=[^<]*#DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}#1' | \
		sed 's#DOCKER_IMAGE_TAG=[^<]*#DOCKER_IMAGE_TAG=${DOCKER_IMAGE_TAG}#1' | \
		sed 's#DOCKER_CONTAINER_NAME=[^<]*#DOCKER_CONTAINER_NAME=${DOCKER_CONTAINER_NAME}#1' | \
		sed 's#APPLICATION_PORT=[^<]*#APPLICATION_PORT=${APPLICATION_PORT}#1' | \
		sed 's#PROFILE=[^<]*#PROFILE=${ENV}#1' \
		> ${BASE_PATH}/deploy/bin/deployment/run-mapping.sh.newVersion && \
		mv ${BASE_PATH}/deploy/bin/deployment/run-mapping.sh.newVersion ${BASE_PATH}/deploy/bin/deployment/run-mapping.sh
	@cat ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress | \
		sed 's#app.port#${APPLICATION_PORT}#g' \
		> ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress.newVersion && \
		mv ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress.newVersion ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress
	@cat ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress-logless | \
		sed 's#app.port#${APPLICATION_PORT}#g' \
		> ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress-logless.newVersion && \
		mv ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress-logless.newVersion ${BASE_PATH}/deploy/docker/Dockerfile-alpine-server-jre-template-pre_uncompress-logless


#
docker.build:
	sh ${BASE_PATH}/deploy/bin/integration/build.sh $(DOCKER_REPOSITORY_NAME) $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_TAG) $(ENV)

#
docker.build.logless:
	sh ${BASE_PATH}/deploy/bin/integration/build-logless.sh $(DOCKER_REPOSITORY_NAME) $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_TAG) $(ENV)

#
docker.push:
	sh ${BASE_PATH}/deploy/bin/integration/push.sh $(DOCKER_REPOSITORY_NAME) $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_TAG) $(ENV)
# ----------------------------- docker >-----------------------------
