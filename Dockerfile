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
RUN pip3 -q install awscli
RUN echo '#!/bin/sh -x' >> /usr/local/bin/kcl-demo-setup
RUN echo 'aws --region=us-east-1 --no-verify-ssl kinesis create-stream --stream-name demo --shard-count 1' >> /usr/local/bin/kcl-demo-setup
RUN chmod +x /usr/local/bin/kcl-demo-setup
RUN echo 'aws --region=us-east-1 --no-verify-ssl kinesis describe-stream --stream-name demo' >> /usr/local/bin/kcl-demo-setup
