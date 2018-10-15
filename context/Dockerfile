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
ENV PIP_USER=1 \
    PATH=$PATH:/home/user/.local/bin
RUN pip3 --no-cache-dir -q install amazon_kclpy \
                                   awscli
