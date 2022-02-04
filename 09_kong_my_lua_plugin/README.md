docker logs kong-gateway
docker exec -it kong-gateway bash
docker exec -it -u root kong-gateway bash
cd /usr/local/share/lua/5.1/kong/plugins/hello
luarocks make hello-world-1.1-1.rockspec

# Step
-   Build image and add custom plugin in Dockerfile
-   Enable plugin 'hello-world' in kong.conf at attribule plugin
-   Using 'hello-world' plugin configuration in kong_declarative_conf.yml

Test
curl -v http://localhost:8000/httpbin/ip

# TIP

# After modify Declarative file
kong reload -c /usr/local/kong/declarative/kong.yml

# Validate config file
kong config parse /usr/local/kong/declarative/kong.yml --vv

# Copy file Kong Plugin in container to Host
docker cp kong-gateway:/usr/local/share/lua/5.1/kong/plugins/basic-auth ./plugins
docker cp kong-gateway:/usr/local/share/lua/5.1/kong/plugins/correlation-id ./plugins
docker cp kong-gateway:/usr/local/share/lua/5.1/kong/plugins/ip-restriction ./plugins