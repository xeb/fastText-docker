.PHONY: all

all: build

DOCKER_IMAGE_PREFIX=xebxeb/fasttext# must be lower case

build:
	docker build -t $(DOCKER_IMAGE_PREFIX) -f Dockerfile .

run:
	docker run --rm -it $(DOCKER_IMAGE_PREFIX) /bin/bash
