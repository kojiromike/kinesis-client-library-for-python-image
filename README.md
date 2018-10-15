# Kinesis Client Library for Python Docker Image

This is the code that builds an opinionated base image for installing applications that run in the [AWS Kinesis Client Library for Python][kclpy].

## Prerequisites

This product and its documentation are intended for users who have a good basic understanding of [Docker](https://docs.docker.com/), [Kinesis](https://docs.aws.amazon.com/streams/latest/dev/introduction.html) and [Python Packaging](https://packaging.python.org/). However, if you are confused, please feel free to create an issue in this project describing your confusion, and I'll attempt to clarify.

## Rationale

Docker images are often abused by being built more from scratch than necessary, because base images are a little too primitive to be used to deliver working software. The [official Docker images](https://hub.docker.com/explore/) contain either a completely finished service product, such as [a database](https://hub.docker.com/_/postgres/), or a build environment, such as [python](https://hub.docker.com/_/python/) or even more generically, [ubuntu](https://hub.docker.com/_/ubuntu/). As a result, we all waste a lot of time and energy running package managers and copying files from a github repo into docker images to build up the same base images over and over, when all we really want is to install a Python package into its intended runtime environment.

This product aims to save you time by providing a reliable, standard interface for installing a Python application into a pre-existing KCL for Python environment.

## Usage

Follow along with this example Dockerfile to see the intended use of this image as a base image:

```Dockerfile
FROM kojiromike/kclpy
COPY my-package.whl . # Skip if your package is on pypi.
RUN pip install my-package
COPY *.properties . # Provide a properties file per the KCL for Python docs.
```

Then build the image. If all goes well, you'll have an image that will run your python app in the KCL.

## How to Build Locally

The image is built automatically on the Docker hub, but if you want to build this image locally, you can run

```
make
```

which will build and tag the image, or you can run

```
docker build [args] context
```

if you want to have more control over docker build arguments.


## How to Test

We can use the sample application that [awslabs](https://github.com/awslabs/) provides with in the [AWS Kinesis Client Library for Python repository][kclpy] to test that this image meets its goal, and to provide a sort-of reference implementation. We use [localstack](https://github.com/localstack/localstack/) to avoid connecting to real AWS endpoints.

Start localstack, then get its port numbers for various services:

```bash
docker-compose up -d
kinesis_endpoint=$(docker-compose port kinesis 443)
kinesis_endpoint="https://localhost:${kinesis_endpoint#*:}"
aws --region=us-east-1 --no-verify-ssl --endpoint-url="$kinesis_endpoint" \
    kinesis create-stream --stream-name demo --shard-count 1
```

If you build the image locally, please keep in mind that `docker-compose.yml` is configured to expect the image to be tagged `kojiromike/kclpy`.


## Running your own Program

### Writing Your Program

Implement [the RecordProcessor interface](https://docs.aws.amazon.com/streams/latest/dev/kinesis-record-processor-implementation-app-py.html#kinesis-record-processor-implementation-interface-py). Beware that there are two versions, which have somewhat different interfaces. You can code to whichever version suits you.

### Installing your Program

This image is designed for you to easily install a Python 3 package from a compatible repository. If your package is open source and available on pypi, then you can just

```
pip install your-package
```

Pip will run in [user mode](https://pip.pypa.io/en/stable/user_guide/#user-installs), so you don't need root privileges. The package will be installed in `/home/user/.local`, but you don't need to do anything special -- the environment is configured for user-mode python.


## Issues and Shortcomings

[It is not possible to override aws API endpoints in the python library right now](https://github.com/awslabs/amazon-kinesis-client/issues/308#issuecomment-415466119). We make the following compromises to point clients to local endpoints for demonstration and local development purposes:
- Use docker links (a deprecated docker feature) to make the real AWS endpoints point to the fake local endpoints.
- Disable SSL cert checking so that the fake endpoints self-signed certificate are accepted.
- Run multiple localstack containers each with internal port 443 exposed, so that the fake local endpoints are all on port 443, rather than running all aws services in a single container and allowing docker to randomize ports.

[kclpy]: https://github.com/awslabs/amazon-kinesis-client-python
