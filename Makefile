.PHONY: all

all: clean build

DOCKER_IMAGE_PREFIX=xebxeb/fasttext-docker# must be lower case

clean:
	rm -rf data
	rm -rf result

pull:
	docker pull $(DOCKER_IMAGE_PREFIX)

build:
	docker build -t $(DOCKER_IMAGE_PREFIX) -f Dockerfile .

run:
	docker run --rm -it $(DOCKER_IMAGE_PREFIX) /bin/bash

example:
	./classification-docker-example.sh

publish:
	docker push $(DOCKER_IMAGE_PREFIX)
