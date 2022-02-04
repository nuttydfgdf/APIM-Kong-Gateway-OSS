
docker-compose up -d --force-recreate

docker exec -it kong-database bash
```
psql -U konga_adm -h localhost -d db_konga
\l #List databases
\c <db-name> #Change database
\dt #Display tables
```

docker exec -it kong-gateway bash
```
cd /usr/local/kong/logs/
cat file-log.log #The filename depends on you declared in the 'file-log' plugin configured in the kong declarative config.xml section of the plugin.
tail -f file-log.log
```

# Filebeat 
cd /filebeat
./filebeat test config


# Logstash Monitor API
http://localhost:9600/

## STEP 2 - INSTALLING
You can either configure the TCP Log plugin to work with a Kong Service, Route or Consumer:

To configure the plugin to work on a Service, use:
```
LOGSTASH_HOST=logstash
LOGSTASH_PORT=5000
SERVICE_ID=httpbin-service

curl -X POST http://localhost:8001/services/${SERVICE_ID}/plugins \
    --data "name=tcp-log"  \
    --data "config.host=$LOGSTASH_HOST" \
    --data "config.port=$LOGSTASH_PORT" \
    --data "config.tls=false"        
```

To configure the plugin to work on a Route, use:

```
curl -X POST http://localhost:8001/routes/{route_id}/plugins \
    --data "name=tcp-log"  \
    --data "config.host=$LOGSTASH_HOST" \
    --data "config.port=$LOGSTASH_PORT" \
    --data "config.tls=false"      
```

To configure the plugin to work on a Consumer, use:
```
curl -X POST http://localhost:8001/plugins \
    --data "name=tcp-log" \
    --data "consumer_id={consumer_id}"  \
    --data "config.host=$LOGSTASH_HOST" \
    --data "config.port=$LOGSTASH_PORT" \
    --data "config.tls=false"     
```

## STEP 3 - SENDING LOGS
You can test sending a log from Kong by sending a request to the service url:
```
curl --url http://localhost:8000/ --header 'Host: example.com'
```
This will display a log in Kibana. You can use your Logit.io stack's Logstash filters to better structure incoming Kong logs.