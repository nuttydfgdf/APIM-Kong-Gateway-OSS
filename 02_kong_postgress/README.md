

# Run
Before run remove volumn
```
docker volume rm kong_database
```

# Install Deck
Go to inside container
```
docker exec -it kong-gateway sh
# With root user
docker exec -u 0 -it kong-gateway bash
```

Install Deck
https://docs.konghq.com/deck/1.10.x/installation/
```
cd /home/kong
wget -O deck.tar.gz https://github.com/kong/deck/releases/download/v1.8.2/deck_1.8.2_linux_amd64.tar.gz
tar -xf deck.tar.gz -C /tmp
cp /tmp/deck /usr/local/bin/
```

## Restore Declaretive file with Deck
deck validate -s /usr/local/kong/declarative/kong.yml
deck sync -s /usr/local/kong/declarative/kong.yml

# Configuring a Service

1.  Add your Service using the Admin API
```
$ curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=example-service' \
  --data 'url=http://mockbin.org'
```

2. Add a Route for the Service
```
$ curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'hosts[]=example.com'
```

3. Test Forward your requests through Kong
```
$ curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'
```