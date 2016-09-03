# fastText Docker [![Build Status](https://travis-ci.org/xeb/fastText-docker.svg?branch=master)](https://travis-ci.org/xeb/fastText-docker) [![Container Status](https://images.microbadger.com/badges/image/xebxeb/fasttext-docker.svg)](https://microbadger.com/images/xebxeb/fasttext-docker "Get your own image badge on microbadger.com")
Dockerfile and example for Facebook Research's [fastText](https://github.com/facebookresearch/fastText).

# Quick Deployments
If you'd like to use a cluster manager to deploy fastText-docker, we have configurations for:
- [Kubernetes](deployments/kubernetes/)
- [Jelastic](deployments/jelastic/) <a href="https://jelastic.com/install-application/?manifest=https://github.com/xeb/fastText-docker/raw/master/deployments/jelastic/jelastic.jps"><img src="https://raw.githubusercontent.com/sych74/PokemonGo-Map-in-Cloud/master/images/deploy-to-jelastic.png" width="125" /></a>

See more in [deployments](deployments/)

# Getting Started
The quickest way to see the fastText classification tutorial with fastText-docker is:
```
docker pull xebxeb/fasttext-docker
mkdir -p /tmp/data && mkdir -p /tmp/result
docker run --rm -v /tmp/data:/data -v /tmp/result:/result -it xebxeb/fasttext-docker ./classification-example.sh
```

**NOTE**: if you ran the above on macOS, the data & results are going to be on your Docker Machine VM.  Use a path in ```/Users/${USER}/``` if you want to map to your local system.  Or do something like: ```docker-machine ssh `docker-machine active` ls /tmp/data``` to see the files in your VM.

# Types of Dockerfiles
There are two Dockerfiles, including:
- **Dockerfile** all-in-one, used for development purposes.  Includes the fastText binary, the entire source repository and Python dependencies.
- **Dockerfile.binary** just for executing the fastText binary.  The fasttext binary is the container's entrypoint.

# Pulling Prebuilt Images
If you'd like to use the published prebuilt images, you can pull them from DockerHub.  *NOTE*: the _latest_ will always be the *devel* tag.
```
docker pull xebxeb/fasttext-docker
docker pull xebxeb/fasttext-docker:devel
docker pull xebxeb/fasttext-docker:binary
```

# Development Container
## Building Devel
To build the devel Docker image, simply do a ```make``` after cloning or:
```
docker build -t fasttext .
```
Building the docker image will create the fasttext binary as well as clone the repository -- all in the root of the container.  
There is no entrypoint for the *devel* container and any of the examples in the [fastText](https://github.com/facebookresearch/fastText) repository will work.

## Using Devel
The development container is meant to be interactive, so the best way to use it is probably with a mounted volume and bash.
```
$ mkdir -p /tmp/data && mkdir -p /tmp/result
$ docker run --rm -it -v /tmp/data:/data -v /tmp/result:/result fasttext /bin/bash
# ./fasttext
usage: fasttext <command> <args>

The commands supported by fasttext are:

  supervised       train a supervised classifier
  test             evaluate a supervised classifier
  predict          predict most likely label
  skipgram         train a skipgram model
  cbow             train a cbow model
  print-vectors    print vectors given a trained model

# ./classification-example.sh
Resolving googledrive.com (googledrive.com)... 216.58.194.33, 2607:f8b0:4000:802::2001
Connecting to googledrive.com (googledrive.com)|216.58.194.33|:443... connected.
HTTP request sent, awaiting response... 302 Moved Temporarily
....
dbpedia_csv/
dbpedia_csv/classes.txt
dbpedia_csv/test.csv
dbpedia_csv/train.csv
dbpedia_csv/readme.txt
make: Nothing to be done for `opt'.
Read 32M words
Progress: 50.2%  words/sec/thread: 1833592  lr: 0.049821  loss: 0.141374  eta: 0h0m

```
You get the idea... it's a full interactive shell with a mounted volume.

**NOTE** be sure to use absolute paths in your local mount arguments!  And if you are on macOS, be sure that your path is within /Users/ -- otherwise you will map to a path on your Docker Machine VM. See [classification-example.sh](examples/classification-example.sh) for an example.

# Binary Container
## Building Binary
If you'd just like a pre-built binary of fastText, you can build the *binary* simply by doing:
```
mark binary
```
(and modifying the Makefile to your image name if you'd like)


## Using Binary
You will likely want to mount a volume with Docker in order to use the binary container because it has an entrypoint of the fasttext binary.  For example:

```
docker run --rm -v /var/path/to/data:/data -v /var/path/to/results:/results test "/result/dbpedia.bin" "/data/dbpedia.test"
docker run --rm -v /var/path/to/data:/data -v /var/path/to/results:/results predict "/result/dbpedia.bin" "/data/dbpedia.test" > "data/dbpedia.test.predict"
```
See [classification-example.sh](examples/classification-example.sh) for an example using the **devel** tag.  Simply replace that with **binary** and remove the _./fastText_ argument to achieve the same result.
