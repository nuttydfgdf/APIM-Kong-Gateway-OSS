## Debug

docker-compose up -d
docker-compose ps
docker-compose logs
docker-compose exec kong-database bash
docker-compose exec kong-gateway bash -c "kong check -vv" 
docker-compose exec kong-gateway bash -c "kong config" 

docker-compose down -v


Go to http://localhost:8002/ (Kong Manager free mode)

//Get SSL Certificate from API Proxy 
openssl s_client -connect kong-apigw.local.net:8443


## OAuth Client Credential
### Pre-requisite

### Pre-requisite: Create a Consumer/Developer
You need to associate a credential to an existing Consumer object. To create a Consumer, you can execute the following request:
```
curl -vk -X POST https://localhost:8444/consumers/ \
  --data "username=DeveloperA" \
  --data "custom_id=SOME_CUSTOM_ID"
```

### Pre-requisite: Create an Application
Then you can finally provision new OAuth 2.0 credentials (also called “OAuth applications”) by making the following HTTP request:
```
curl -vk -X POST https://localhost:8444/consumers/DeveloperA/oauth2 \
  --data "name=demo-app" \
  --data "client_id=demo-app" \
  --data "client_secret=1234" \
  --data "redirect_uris=http://some-domain/endpoint/" \
  --data "hash_secret=true"
```

### Try to get OAuth token OAuth 2.0 Flows : Client Credentials
Using a POST request, set Content-Type to application/x-www-form-urlencoded and send the credentials as form data:
```
curl -ivk -X POST 'https://localhost:8443/httpbin/oauth2/token' \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'client_id=demo-app' \
  --data-urlencode 'client_secret=1234' \
  --data-urlencode 'grant_type=client_credentials'
```
> Kong can apply OAuth2 each service/route. In this case we apply plugin at route [httpbin-secure]


### Viewing and Invalidating Access Tokens by Admin API
Active tokens can be listed and modified using the Admin API. A GET on the /oauth2_tokens endpoint returns the following:
```
curl -ivk GET https://localhost:8444/oauth2_tokens/
```

## Simple Loadtest
Get token 
```
k6 run k6-script/script-loadtest-get-token.js
```

Get token and call API
```
k6 run k6-script/script-httpbin-secure.js
```

### Services

All services include these:

| Service name   | Required | *Expose Port | Internal Port |  Description |
|----------      |:--:|:--:|:--:|------|
| kong-database  |  / | 5432 |5432 |storage data in kong-gateway
| kong-migration |  / | - | - |Util for Database bootstrapped.
| kong-gateway   |  / | 8000, 8443<br> 8001, 8444 | 8000, 8443<br> 8001, 8444 |  
| konga-database |  / | | 5432 |      | 
| konga          |  / | 9000 | 1337 | Konga is Kong Admin GUI Dashboard for Kong Community Edition solution
| prometheus     |    | 9090 | 9090 | From metrics to insight Power your metrics and alerting with a leading open-source monitoring solution.
| node_exporter  |    | 9100 | 9100 | Prometheus exporter for hardware and OS metrics exposed by *NIX kernels, written in Go with pluggable metric collectors.
<br>

> *The expose port we can specify by ourselves in the file. docker-compose or .env file

> If you don't want to create unnecessary services
You can disable it in docker-compose file.