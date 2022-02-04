FROM kong:2.1.3

LABEL description="Alpine + Kong 2.1.3 + Filebeat"

# Build variables
ENV FILEBEAT_VERSION=6.1.1
ENV FILEBEAT_URL=https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz
ENV env=DEVELOPMENT
ENV project=KONG_ELK_FILEBEAT

USER root
RUN apk update
# RUN apk --no-cache add curl
# RUN apk add --update-cache curl bash libc6-compat && \
#     rm -rf /var/cache/apk/*
RUN apk add curl
RUN apk add bash libc6-compat && \
    rm -rf /var/cache/apk/*

# Install Filebeat -----------------------------------------
RUN curl ${FILEBEAT_URL} -o /filebeat.tar.gz && \
    tar xzvf filebeat.tar.gz && \
    rm filebeat.tar.gz && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64 filebeat && \
    cd filebeat && \
    cp filebeat /usr/bin

RUN rm -rf /filebeat/filebeat.yml
COPY ./config/filebeat.yml /filebeat/
RUN chmod go-w /filebeat/filebeat.yml

RUN mkdir -m 777 -p /filebeat/data
RUN mkdir -m 777 -p /filebeat/logs
WORKDIR /filebeat
RUN filebeat -e -c /filebeat/filebeat.yml &

# -----------------------------------------------------------

USER kong