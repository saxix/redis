# envs to set before use this script
VERSION=6.0.10
DOCKER_IMAGE_NAME=saxix/redis
DOCKER_IMAGE=${DOCKER_IMAGE_NAME}:${VERSION}
DOCKER_TARGET=${DOCKER_IMAGE}
DOCKERFILE?=Dockerfile
CONTAINER_NAME=saxix_redis
#CMD=redis-server
define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)


build:  ## build docker image
	docker build \
			${BUILD_OPTIONS} \
			-t ${DOCKER_IMAGE} \
			-f ${DOCKERFILE} .
	docker images | grep ${DOCKER_IMAGE_NAME}

release:  ## relase version $VERSION
	docker tag ${DOCKER_IMAGE_NAME}:${VERSION} ${DOCKER_IMAGE_NAME}:latest
	docker push ${DOCKER_IMAGE_NAME}:latest
	docker push ${DOCKER_IMAGE_NAME}:${VERSION}

.run:
	docker run \
		--rm \
		--name=${CONTAINER_NAME} \
		${RUN_OPTIONS} \
		${DOCKER_IMAGE} \
		${CMD}

run:  ## run image locally
	CMD=start $(MAKE) .run

test:  ## test docker image
	CMD='sh -c "whoami && django-admin check --deploy"' \
	$(MAKE) .run


shell:  ## run docker and spawn a shell
	RUN_OPTIONS=-it CMD='/bin/bash' $(MAKE) .run

check:  ## run docker and spawn a shell
	RUN_OPTIONS=-it CMD='check' $(MAKE) .run
