FROM ubuntu:14.04
RUN apt-get update && apt-get install -y \
        build-essential \
        wget \
        git \
        python-dev \
        python-numpy \
        python-scipy \
        && rm -rf /var/cache/apk/*

RUN git clone https://github.com/facebookresearch/fastText.git /tmp/fastText
RUN rm -rf /tmp/fastText/.git* && \
  mv /tmp/fastText/* / && \
  cd / && \
  make
WORKDIR /
CMD ["./fasttext"]
