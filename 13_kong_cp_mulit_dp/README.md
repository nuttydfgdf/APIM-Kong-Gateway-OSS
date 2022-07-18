
```bash
cd 13_kong_cp_mulit_dp
# docker stack deploy --compose-file <File> <StackName>
docker stack deploy --compose-file docker-compose.yml kong
```

> Docker stack doesn't support .env file.
docker stack deploy -c <(docker-compose config) kong


> Pretty correct, swarm as a orchestration will ignore the depends_on.
But for your scenario, depends_on is really not necessary as you already have wait-for-it.sh which have better control than depends_on to assure the start order.


Check that it’s running with docker stack services stackdemo:
```
STACK_NAME=kong
docker stack ls
docker stack services ${STACK_NAME}
docker stack ps ${STACK_NAME}
docker service ls
docker service logs -f kong_kong-cp
docker service logs -f kong_kong-dp
docker service logs -f kong_kong-database
docker service logs -f kong_kong-migration
docker service logs -f --tail=100 kong_kong-dp
```
> For remove stack : docker stack rm ${STACK_NAME} 


output
```
nutsu@Nut:/mnt/d/sourcetree/github/nuttydfgdf/APIM-Kong-Gateway-OSS/13_kong_cp_mulit_dp$ docker stack services ${STACK_NAME}
ID             NAME                  MODE         REPLICAS   IMAGE                              PORTS
qvy43pcr1r1o   kong_kong-cp          replicated   1/1        kong/kong-gateway:2.8.0.0-alpine   *:8000-8002->8000-8002/tcp, *:8005-8006->8005-8006/tcp, *:8100->8100/tcp, *:8443-8444->8443-8444/tcp
nmaz60mdx004   kong_kong-database    replicated   1/1        postgres:9.6                       *:5432->5432/tcp
20b1zm5990mf   kong_kong-dp          replicated   1/1        kong/kong-gateway:2.8.0.0-alpine   *:8080->8080/tcp
rctdmu2zsxk5   kong_kong-migration   replicated   0/1        kong/kong-gateway:2.8.0.0-alpine
```
```
nutsu@Nut:/mnt/d/sourcetree/github/nuttydfgdf/APIM-Kong-Gateway-OSS/13_kong_cp_mulit_dp$ docker service ls
ID             NAME                  MODE         REPLICAS   IMAGE                              PORTS
qvy43pcr1r1o   kong_kong-cp          replicated   1/1        kong/kong-gateway:2.8.0.0-alpine   *:8000-8002->8000-8002/tcp, *:8005-8006->8005-8006/tcp, *:8100->8100/tcp, *:8443-8444->8443-8444/tcp
nmaz60mdx004   kong_kong-database    replicated   1/1        postgres:9.6                       *:5432->5432/tcp
20b1zm5990mf   kong_kong-dp          replicated   1/1        kong/kong-gateway:2.8.0.0-alpine   *:8080->8080/tcp
rctdmu2zsxk5   kong_kong-migration   replicated   0/1        kong/kong-gateway:2.8.0.0-alpine
```

If you find Control-Plane REPLICAS 0/1 you can restart the container again because sometimes Control-Plane Quick start up before the system's initial database is complete (step kong migrations bootstrap).
```
docker service update kong_kong-cp
```

## Get Ingress IP

Also, you could use the below command to verify your LISTEN ports:
```
netstat -tulpn
```
> but if you use wsl2 on window you can access the service with eth0 
At the WSL terminal try 'ip a show eth0' and look for eth0 ip
```
$ ip a show eth0
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:31:06:d6 brd ff:ff:ff:ff:ff:ff
    inet 172.19.86.233/20 brd 172.19.95.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fe31:6d6/64 scope link
       valid_lft forever preferred_lft forever
```

```
INGRESS_IP=172.19.94.64
curl http://${INGRESS_IP}:8001
```



## Verify that nodes are connected

curl -i -X GET http://<admin-hostname>:8001/clustering/data-planes
```
curl -i -X GET http://${INGRESS_IP}:8001/clustering/data-planes
```


## Scale Data Plane
Run the following command to change the desired state of the service running in the swarm:
docker service scale <SERVICE-ID>=<NUMBER-OF-TASKS>
For example:
```
docker service scale kong_kong-dp=2
```

Output
```
$ docker service ls
ID             NAME                  MODE         REPLICAS   IMAGE                              PORTS
qvy43pcr1r1o   kong_kong-cp          replicated   1/1        kong/kong-gateway:2.8.0.0-alpine   *:8000-8002->8000-8002/tcp, *:8005-8006->8005-8006/tcp, *:8100->8100/tcp, *:8443-8444->8443-8444/tcp
nmaz60mdx004   kong_kong-database    replicated   1/1        postgres:9.6                       *:5432->5432/tcp
20b1zm5990mf   kong_kong-dp          replicated   2/2        kong/kong-gateway:2.8.0.0-alpine   *:8080->8080/tcp
rctdmu2zsxk5   kong_kong-migration   replicated   0/1        kong/kong-gateway:2.8.0.0-alpine
```

You can publish ports by updating the service.
```
docker service update <your-service> --publish-add 80:8000
docker service update kong_kong-dp --publish-add 8080:8080
```
> Delete : docker service update kong_kong-dp --publish-rm 80:8000


## Create Route & Service 
```bash
ADMIN_ENDPOINT=http://localhost:8001
curl -i -X POST \
  --url ${ADMIN_ENDPOINT}/services/ \
  --data 'name=httpbin-service' \
  --data 'url=https://httpbin.org'
```

2. Add a Route for the Service
```bash
curl -i -X POST \
  --url ${ADMIN_ENDPOINT}/services/httpbin-service/routes \
     -d "name=httpbin-route" \
     -d "paths[]=/httpbin"
```

4. Curl 
```bash
curl -i -X GET \
  --url http://${INGRESS_IP}:8080/httpbin/status/200
```

Open the tail service log and view the traffic path to the data-plane instance1 and instance2.
```bash
$ docker service logs -f kong_kong-dp

kong_kong-dp.2.zauq0zmhwaed@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:15 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.0"
kong_kong-dp.1.0znzndc2s28k@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:16 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.0"
kong_kong-dp.2.zauq0zmhwaed@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:17 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.0"
kong_kong-dp.1.0znzndc2s28k@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:18 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.0"
kong_kong-dp.2.zauq0zmhwaed@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:19 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.0"
kong_kong-dp.1.0znzndc2s28k@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:20 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.0"
kong_kong-dp.2.zauq0zmhwaed@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:21 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.0"
kong_kong-dp.1.0znzndc2s28k@Nut    | 10.0.0.2 - - [18/Jul/2022:04:01:22 +0000] "GET /httpbin/status/200 HTTP/1.1" 200 0 "-" "curl/7.68.
```

### Using Apache Bench for Simple Load Testing
Apache Bench or ab for short, is a command-line tool to perform simple load tests on an HTTP server, be it a website or an API.
By running the following command, you will get an overview of how the server is performing under load:
```bash
ab -n 100 -c 10 <url>
```

```
apt-get update
apt-get install apache2-utils
ab -V
```

```bash
URL=https://httpbin.org/status/200
ab -n 1 -c 1 $URL
```
> -n: Number of requests
> -c: Number of concurrent requests


# Clean
```bash
docker stack rm kong
```

