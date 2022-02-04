FROM kong:2.1.3

LABEL description="Alpine + Kong 2.1.3 + Filebeat"
ENV FILEBEAT_VERSION=6.1.1

USER root
# RUN apk update && apk add git unzip luarocks
# RUN luarocks install kong-oidc
RUN apk update
RUN apk --no-cache add curl

# RUN apk add --update-cache curl bash libc6-compat && \
#     rm -rf /var/cache/apk/* && \
#     curl https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -o /filebeat.tar.gz && \
#     tar xzvf filebeat.tar.gz && \
#     rm filebeat.tar.gz && \
#     mv filebeat-${FILEBEAT_VERSION}-linux-x86_64 filebeat && \
#     cd filebeat && \
#     cp filebeat /usr/bin && \
#     rm -rf /filebeat/filebeat.yml && \
#     cp /filebeat.yml /filebeat/ && \
#     ls -ltr /filebeat && \
#     cat /filebeat/filebeat.yml

USER kong