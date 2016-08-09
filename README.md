# fastText Docker
Dockerfile and examples for Facebook Research's fastText

# Building
To build the docker image, simply do a ```make``` or:
```
docker build -t fasttext .
```
Building the docker image will also create the fasttext binary in the root of the container.  
There is no entrypoint for the container and any of the examples in the [fastText](https://github.com/facebookresearch/fastText) repository will work.


# Running Examples
In order to run fasttext, once the container has built, you'll need to specify the script or binary to execute inside the container.  Also take note that you'll likely want to copy relevant data into the container as needed.

For example, to run ```classification-example.sh```, use the following command:

```
docker run -it fasttext ./classification-example.sh
```

If you have a local file, you can mount a docker volume or copy it into a running container.  See the [example.sh](example.sh) for the *classification-example* using only Docker containers for execution.
  
```
./example.sh
```
