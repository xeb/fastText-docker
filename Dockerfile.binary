# See Makefile for how to build with this Dockerfile
FROM ubuntu:xenial
MAINTAINER Mark Kockerbeck <mark@kockerbeck.com>
ADD fasttext.bin /fasttext
WORKDIR /
ENTRYPOINT ["./fasttext"]
CMD ["help"]
