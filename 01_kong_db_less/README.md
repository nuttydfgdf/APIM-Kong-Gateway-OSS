# Get Started
We will run Kong OSS using docker-compose. In this chapter, we'll show you how to quickly provision a kong with docker.

Go to the current directory and start the container with docker-compose
```
cd 01_kong_db_less
docker-compose up -d
```

View a list of containers
```
docker-compose ps
```
View logs of docker-compose
```
docker-compose logs
```

Try testing the service on Kong Gateway using curl command.
```
curl http://localhost:8000/httpbin/anything
```

Try testing the service on Kong Admin using curl command.
```
curl http://localhost:8001
```

docker logs -f <container-name>
docker logs -f kong-gateway

# kong command (inside container)
```bash
#docker exec -it CONTAINER bash
docker exec -it kong-gateway bash

kong check -vv
kong config

kong start 
kong stop
kong health
kong reload
kong start -c <kong.conf> --vv
```


The template is split in two Nginx configuration files: nginx.lua and nginx_kong.lua. The former is minimal and includes the latter, which contains everything Kong requires to run. When kong start runs, right before starting Nginx, it copies these two files into the prefix directory, which looks like so:
```
/usr/local/kong
├── nginx-kong.conf
└── nginx.conf
```
> See detail https://docs.konghq.com/gateway/latest/reference/configuration/#custom-nginx-templates--embedding-kong

```bash
cat /etc/kong/kong.conf
cat /etc/kong/kong.conf.default
cat /usr/local/kong/nginx.conf
cat /usr/local/kong/nginx-kong.conf
cd /usr/local/kong/logs
kong prepare -p /usr/local/kong && /usr/local/openresty/nginx/sbin/nginx -c /usr/local/kong/nginx.conf -p /usr/local/kong/
```

## Get Config file from container

```bash
#docker cp CONTAINER:/var/logs/ /tmp/app_logs
docker cp kong-gateway:/usr/local/kong/nginx.conf ./temp-clone-config-file
docker cp kong-gateway:/usr/local/kong/nginx-kong.conf ./temp-clone-config-file
```

### Exec as Root
To exec command as root, use the -u option. The option requires a username or UID of the user. For example:

```bash
#docker exec -it CONTAINER bash 
docker exec -it -u 0 kong-gateway bash 
```
