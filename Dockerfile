FROM openjdk as kclpy
WORKDIR /srv
RUN apt-get -qqy update \
 && apt-get -qqy install python3 \
                         python3-pip
RUN pip3 -q install amazon_kclpy \
                    awscli
COPY exec-kcl /usr/local/bin/kcl
ENTRYPOINT ["/usr/local/bin/kcl"]
