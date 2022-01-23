# Konga

## Quick Kong Loopback using Postman
Import collection & environment into Postman.
-  KONG CE Local.postman_collection.json
-  KONG CE Local.postman_environment.json

Go to Collections
   
   Execute [KONG CE Local] - > [Setup Kong LoopBack] 

Using Consumer ID that generated when we're adding consumer, we will use that Consumer ID and generate API Key.
Request

> ** For response, copy key attribute is API Key and go to Konga.
> After create user admin.
> -   Loopback api : http://<host>:8000/admin-api
> -   Key : <response body "key">

> In docker container, host should be service name in docker-compose file
> <br>example : http://kong-gateway:8000/admin-api 
> <br>'kong-gateway' is kong service. Because the konga container must be connected to the kong-gateway proxy port 8000.


<br>


## Setup Kong LoopBack
Thanks to Kong's routing design it's possible to serve Admin API itself behind Kong proxy.

To configure this we need to following steps:

-	Add Kong Admin API as services: You can import postman collection that i already create before or simply copy-paste following commands:

Request
```
curl --location --request POST 'http://localhost:8001/services/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "admin-api",
    "host": "localhost",
    "port": 8001
}'
```

Response
```
{
   "host":"localhost",
   "id":"b6acea54-8e98-43e7-a4f9-92021c45bc12",
   "protocol":"http",
   "read_timeout":60000,
   "tls_verify_depth":null,
   "port":8001,
   "updated_at":1604665194,
   "ca_certificates":null,
   "created_at":1604665194,
   "connect_timeout":60000,
   "write_timeout":60000,
   "name":"admin-api",
   "retries":5,
   "path":null,
   "tls_verify":null,
   "tags":null,
   "client_certificate":null
}
```

-	Add Admin API route: To register route on Admin API Services we need either service name or service id, you can replace the following command below:
Request
```
curl --location --request POST 'http://localhost:8001/services/f6f38111-121a-4e07-8e33-8c7a55a3a968/routes' \
--header 'Content-Type: application/json' \
--data-raw '{
    "paths": ["/admin-api"]
}'
```

Response
```
{
   "id":"180d13db-9108-4a37-84b4-a13e258d9652",
   "tags":null,
   "paths":[
      "\/admin-api"
   ],
   "destinations":null,
   "headers":null,
   "protocols":[
      "http",
      "https"
   ],
   "strip_path":true,
   "created_at":1604665343,
   "request_buffering":true,
   "hosts":null,
   "name":null,
   "updated_at":1604665343,
   "snis":null,
   "preserve_host":false,
   "regex_priority":0,
   "methods":null,
   "sources":null,
   "response_buffering":true,
   "https_redirect_status_code":426,
   "path_handling":"v0",
   "service":{
      "id":"b6acea54-8e98-43e7-a4f9-92021c45bc12"
   }
}
```

-	Now our Kong Admin API is running behind Kong Proxy, so in order to access it you need to :
```
curl localhost:8000/admin-api/
```

## Enable Key Auth Plugin
Our Admin API already run behind kong, but is not secured yet. In order to protect Kong Admin API we need to enable key auth plugin at service level by doing this commands.
Request
```
curl -X POST http://localhost:8001/services/f6f38111-121a-4e07-8e33-8c7a55a3a968/plugins \
    --data "name=key-auth" 
```
Response
```	
{
   "created_at":1604665454,
   "id":"224b5a02-2098-440d-a83a-70bf41da2dc2",
   "tags":null,
   "enabled":true,
   "protocols":[
      "grpc",
      "grpcs",
      "http",
      "https"
   ],
   "name":"key-auth",
   "consumer":null,
   "service":{
      "id":"b6acea54-8e98-43e7-a4f9-92021c45bc12"
   },
   "route":null,
   "config":{
      "key_names":[
         "apikey"
      ],
      "run_on_preflight":true,
      "anonymous":null,
      "hide_credentials":false,
      "key_in_body":false
   }
}
```

-	Add Konga as Consumer
Our Admin API already run behind kong, but is not secured yet. In order to protect Kong Admin API we need to enable key auth plugin at service level by doing this commands.

Request
```
curl --location --request POST 'http://localhost:8001/consumers/' \
--form 'username=konga' \
--form 'custom_id=8fa4b380-2d26-41a3-b7c0-2859d37594ef'
```

Response
```
{
   "custom_id":"224b5a02-2098-440d-a83a-70bf41da2dc2",
   "created_at":1604665546,
   "id":"1844c70d-82eb-4f9d-8873-8fe40ad8287e",
   "tags":null,
   "username":"konga"
}
```

## Create API Key for Konga
Using Consumer ID that generated when we're adding consumer, we will use that Consumer ID and generate API Key.
Request
```
curl --location --request POST 'http://localhost:8001/consumers/71921431-9d0d-417b-8dd7-3527ebfa7071/key-auth'
```

Response
```
{
   "created_at":1604665627,
   "id":"c0a3317f-82ec-4fd7-85f9-31f151d35591",
   "tags":null,
   "ttl":null,
   "key":"Q5Czlw2G5BcmjjMXMzYuuik2Q1GivT4t",
   "consumer":{
      "id":"1844c70d-82eb-4f9d-8873-8fe40ad8287e"
   }
}
```

## Setup Connection
Now we're already have all required component to setup Konga connection
Goto "KEY AUHT"

Name : XX

Loopback API URL : http://kong-gateway:8000/admin-api

API KEY : Q5Czlw2G5BcmjjMXMzYuuik2Q1GivT4t



# Prometheus Plugin
Expose metrics related to Kong and proxied Upstream services in Prometheus exposition format, which can be scraped by a Prometheus Server.

PermalinkConfiguration Reference
You can configure this plugin using the Kong Admin API 

curl -i http://localhost:8001/metrics


# Zipkin
Plugin 
   http endpoint : http://wsl.local:9411/api/v2/spans
   sample ratio : 1
