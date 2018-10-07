# Kinesis Client Library for Python Docker Image

This is the code that builds an opinionated base image for installing applications that run in the [AWS Kinesis Client Library for Python](https://github.com/awslabs/amazon-kinesis-client-python).

## Prerequisites

This product and its documentation are intended for users who have a good basic understanding of [Docker](https://docs.docker.com/), [Kinesis]https://docs.aws.amazon.com/streams/latest/dev/introduction.html) and [Python Packaging](https://packaging.python.org/). However, if you are confused, please feel free to create an issue in this project describing your confusion, and I'll attempt to clarify.

## Rationale

Docker images are often abused by being built more from scratch than necessary, because base images are a little too primitive to be used to deliver working software. The [official Docker images](https://hub.docker.com/explore/) containe either a completely finished service product, such as a database, or a build environment, such as [python](https://hub.docker.com/_/python) or even more generically, [ubuntu](https://hub.docker.com/_/ubuntu). As a result, we all waste a lot of time and energy running package managers and copying files from a github repo into docker images to build up the same base images over and over, when all we really want is to install a Python package.

Instead, this product aims to save you time by providing a reliable, standard interface for installing a Python application into a pre-existing KCL for Python environment.

## Usage

The intended use of this image is as a base image, so follow along with this example Dockerfile:

```Dockerfile
FROM kojiromike/kinesis-client-library-for-python-image
COPY my-package.whl . # Skip if your package is on pypi.
RUN pip install my-package
COPY *.properties . # Provide a properties file per the KCL for Python docs.
```

Then build the image. If all goes well, you'll have an image that will run your python app in the KCL.

## How to Test

To test that the image works as expected, we can use the sample application that awslabs provides with in the AWS Kinesis Client Library for Python repository. We don't want to require connecting to real Kinesis so we use [localstack](https://localstack.cloud/).

Start localstack, then get its port numbers for various services:

```bash
docker-compose up -d
kinesis_endpoint=$(docker-compose port localstack 4568)
kinesis_endpoint="http://localhost:${kinesis_endpoint#*:}"
aws --region=us-east-1 --endpoint-url="$kinesis_endpoint" kinesis create-stream --stream-name demo --shard-count 1
```
