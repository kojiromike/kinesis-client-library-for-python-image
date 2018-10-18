##
# This is the main Dockerfile for the kclpy image.
# Please avoid putting demo-only tools and
# configuration in here.
FROM python:3.7-slim-stretch as kclpy
WORKDIR /srv
# Manually make man dir because of
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN type python pip >&2 \
 && python --version >&2 \
 && pip --version >&2 \
 && mkdir -p /usr/share/man/man1 \
 && apt-get -qqy update \
 && apt-get -qqy install openjdk-8-jre-headless \
 && java -version

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
RUN pip install amazon_kclpy
