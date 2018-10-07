FROM openjdk
RUN apt-get -qqy update
RUN apt-get -qqy install python3
RUN apt-get -qqy install python3-pip
WORKDIR /srv
RUN pip3 -q install amazon_kclpy
COPY *.properties .
RUN echo '#!/bin/sh -x' >> /usr/local/bin/kcl
RUN echo 'exec java -cp $(amazon_kclpy_helper.py --print_classpath) -Dcom.amazonaws.sdk.disableCertChecking com.amazonaws.services.kinesis.multilang.MultiLangDaemon sample.properties' >> /usr/local/bin/kcl
RUN chmod +x /usr/local/bin/kcl
