docker logs kong-gateway
docker exec -it kong-gateway bash
docker exec -it -u root kong-gateway bash
cd /usr/local/share/lua/5.1/kong/plugins/hello
luarocks make hello-world-1.1-1.rockspec

# Example Plugin
https://github.com/Kong/kong/tree/master/kong/plugins

# Step
-   Build image and add custom plugin in Dockerfile
-   Enable plugin 'hello-world' in kong.conf at attribule plugin
-   Using 'hello-world' plugin configuration in kong_declarative_conf.yml

Test
curl -v http://localhost:8000/httpbin/ip

# Plugin Data-masking
Create folder "kong-build" > "plugins" > "data-masking"

Adding data-masking in Dockerfile
```
# Install Custom plugin
COPY ./plugins/data-masking /usr/local/share/lua/5.1/kong/plugins/data-masking
WORKDIR /usr/local/share/lua/5.1/kong/plugins/data-masking
RUN luarocks make data-masking-1.0-9.rockspec
```

Adding kong.conf 
```
plugins = bundled,hello-world,data-masking
```

Test
curl -X POST http://localhost:8000/httpbin/anything \
   -H "Content-Type: application/json" \
   -d '{"productId": 1, "quantity": 10, "creditcard": "5339153509902878", "password":"T7g8d]%Z9#b^;-$"}'

# TIP

# After modify Declarative file
kong reload -c /usr/local/kong/declarative/kong.yml

# Validate config file
kong config parse /usr/local/kong/declarative/kong.yml --vv

# Copy file Kong Plugin in container to Host
docker cp kong-gateway:/usr/local/share/lua/5.1/kong/plugins/basic-auth ./plugins
docker cp kong-gateway:/usr/local/share/lua/5.1/kong/plugins/correlation-id ./plugins
docker cp kong-gateway:/usr/local/share/lua/5.1/kong/plugins/ip-restriction ./plugins



