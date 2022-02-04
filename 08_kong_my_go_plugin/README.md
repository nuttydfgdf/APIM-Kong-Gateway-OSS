# Get Start
> After editing the go src file, you need to build again.

docker-compose build
docker image ls | grep kong
docker-compose up -d
docker-compose ps

investegate issue
docker logs kong-gateway
docker exec -it kong-gateway bash

# Trying to call API Proxy
```
curl http://localhost:8000/httpbin/anything

output
You have no correct key
```

```
curl http://localhost:8000/httpbin/anything?key=mysecretconsumerkey

output
{
  "args": {
    "key": "mysecretconsumerkey"
  },
  "data": "",
  "files": {},
  "form": {},
  "headers": {
    "Accept": "*/*",
    "Host": "httpbin.org",
    "User-Agent": "curl/7.68.0",
    "X-Amzn-Trace-Id": "Root=1-61fca870-7291310034f761cf51efe401",
    "X-Forwarded-Host": "localhost",
    "X-Forwarded-Path": "/httpbin/anything",
    "X-Forwarded-Prefix": "/httpbin"
  },
  "json": null,
  "method": "GET",
  "origin": "172.19.0.1, 171.97.97.30",
  "url": "https://localhost/anything?key=mysecretconsumerkey"
}
```

```
curl http://localhost:8000/httpbin/anything?key=mysecretconsumerkey -v

*   Trying 127.0.0.1:8000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8000 (#0)
> GET /httpbin/anything?key=mysecretconsumerkey HTTP/1.1
> Host: localhost:8000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Content-Length: 535
< Connection: keep-alive
< Server: NUTSU  <<<<!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
< Date: Fri, 04 Feb 2022 04:25:15 GMT
< Server: gunicorn/19.9.0
< Access-Control-Allow-Origin: *
< Access-Control-Allow-Credentials: true
< X-Kong-Upstream-Latency: 1117
< X-Kong-Proxy-Latency: 13
< Via: kong/2.7.0
<.
.
.
```

# Remove Docker image state build
docker rmi `docker images --filter label=builder=true -q`