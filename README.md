"# APIM-KONG-CE" 

### Tip Remove image TAG = <none>
docker images | grep none | awk '{ print $3; }' | xargs docker rmi


# Kong Command
```
kong
kong check
kong config 

kong reload
```

# Kong View Environment variable
```
echo "KONG_ROLE : ${KONG_ROLE}"
echo "KONG_DATABASE : ${KONG_DATABASE}
echo "KONG_PROXY_LISTEN : ${KONG_PROXY_LISTEN}
echo "KONG_CLUSTER_CONTROL_PLANE : ${KONG_CLUSTER_CONTROL_PLANE}
echo "KONG_CLUSTER_TELEMETRY_ENDPOINT : ${KONG_CLUSTER_TELEMETRY_ENDPOINT}
echo "KONG_CLUSTER_CERT : ${KONG_CLUSTER_CERT}
echo "KONG_CLUSTER_CERT_KEY : ${KONG_CLUSTER_CERT_KEY}
```

cd /usr/local/kong/logs
tail -f /usr/local/kong/logs/error.log
cat /usr/local/kong/logs/error.log
tail -f /usr/local/kong/logs/access.log