##
# This is the main Dockerfile for the kclpy image.
# Please avoid putting demo-only tools and
# configuration in here.
FROM openjdk:jre-alpine as kclpy
WORKDIR /srv
RUN apk add --no-cache bash \
                       python3 \
 && bash --version \
 && python3 --version \
 && pip3 --version \
 && type bash pip3 python3

COPY exec-kcl /usr/local/bin/kcl
ENTRYPOINT ["/usr/local/bin/kcl"]

# Run as a non-root user.
RUN adduser -D -s /bin/bash user \
 && chown -R user:user /srv
USER user
ENV PATH=$PATH:/home/user/.local/bin \
    PIP_NO_CACHE_DIR=off \
    PIP_QUIET=1 \
    PIP_USER=1
RUN pip3 install --disable-pip-version-check --upgrade pip setuptools \
 && type pip \
 && pip --version
RUN pip install amazon_kclpy awscli \
 && type aws \
 && aws --version
