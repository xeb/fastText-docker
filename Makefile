.PHONY: all

all: clean build binary

DOCKER_IMAGE_PREFIX=xebxeb/fasttext-docker# must be lower case

clean:
	rm -rf examples/data
	rm -rf examples/result

build:
	docker build -t $(DOCKER_IMAGE_PREFIX):devel -f Dockerfile .
	docker build -t $(DOCKER_IMAGE_PREFIX):latest -f Dockerfile .

binary: build
	docker run --rm $(DOCKER_IMAGE_PREFIX):devel cat ./fasttext > fasttext.bin
	chmod +x fasttext.bin
	docker build -t $(DOCKER_IMAGE_PREFIX):binary -f Dockerfile.binary .
	rm fasttext.bin

# -----
# Other make options below
# -----

test:
	docker run --rm -it $(DOCKER_IMAGE_PREFIX):devel ./word-vector-example.sh
	docker run --rm -it $(DOCKER_IMAGE_PREFIX):devel ./classification-example.sh
	docker run --rm -it $(DOCKER_IMAGE_PREFIX):devel ./classification-results.sh

run:
	docker run --rm -it $(DOCKER_IMAGE_PREFIX):devel /bin/bash

example:
	cd examples && ./classification-example.sh

publish:
	docker push $(DOCKER_IMAGE_PREFIX):devel
	docker push $(DOCKER_IMAGE_PREFIX):latest
	docker push $(DOCKER_IMAGE_PREFIX):binary
