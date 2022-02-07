FROM kong:2.7.0-alpine

LABEL description="At"

USER root
# RUN apk update && apk add git unzip luarocks
# RUN luarocks install kong-oidc
RUN apk update
RUN apk --no-cache add curl

# Install Custom plugin
COPY ./plugins/hello-world /usr/local/share/lua/5.1/kong/plugins/hello-world
WORKDIR /usr/local/share/lua/5.1/kong/plugins/hello-world
RUN luarocks make hello-world-1.1-1.rockspec


# Install Custom plugin
COPY ./plugins/data-masking /usr/local/share/lua/5.1/kong/plugins/data-masking
WORKDIR /usr/local/share/lua/5.1/kong/plugins/data-masking
RUN luarocks make data-masking-1.0-9.rockspec


USER kong