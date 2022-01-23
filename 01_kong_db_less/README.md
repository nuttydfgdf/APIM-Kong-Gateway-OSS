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