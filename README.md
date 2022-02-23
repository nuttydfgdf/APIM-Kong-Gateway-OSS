"# APIM-KONG-CE" 

### Tip Remove image TAG = <none>
docker images | grep none | awk '{ print $3; }' | xargs docker rmi