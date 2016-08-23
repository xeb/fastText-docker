FROM ubuntu:14.04
MAINTAINER Mark Kockerbeck <mark@kockerbeck.com>
RUN apt-get update && apt-get install -y \
        build-essential \
        wget \
        git \
        python-dev \
        unzip \
        python-numpy \
        python-scipy \
        && rm -rf /var/cache/apk/*

RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText && \
  rm -rf /tmp/fastText/.git* && \
  mv /tmp/fastText/* / && \
  cd / && \
  make

WORKDIR /
CMD ["./fasttext"]
