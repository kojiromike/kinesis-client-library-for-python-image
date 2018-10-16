##
# This is the main Dockerfile for the kclpy image.
# Please avoid putting demo-only tools and
# configuration in here.
FROM openjdk:jre-slim as kclpy
WORKDIR /srv
RUN apt-get -qqy update \
 && apt-get -qqy install python3 \
                         python3-pip \
 && rm -rf /var/lib/apt/lists/*

COPY exec-kcl /usr/local/bin/kcl
ENTRYPOINT ["/usr/local/bin/kcl"]

# Run as a non-root user.
RUN useradd -m user \
 && chown -R user:user /srv
USER user
ENV PATH=$PATH:/home/user/.local/bin \
    PIP_NO_CACHE_DIR=off \
    PIP_QUIET=1 \
    PIP_USER=1
RUN pip3 install --upgrade pip setuptools \
 && type pip \
 && pip install amazon_kclpy awscli
