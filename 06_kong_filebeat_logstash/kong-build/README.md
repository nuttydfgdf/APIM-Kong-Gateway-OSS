# Go to inside image, after build
docker run -it name-of-image bash
docker run -it 06_kong_filebeat_elk_kong-gateway
docker run -it 06_kong_filebeat_elk_kong-gateway bash


# kong command
kong check -vv
kong config

kong start 
kong stop
kong health
kong reload
kong start -c <kong.conf> --vv

cat /usr/local/kong/nginx.conf
cat /usr/local/kong/nginx-kong.conf
cd /usr/local/kong/logs
kong prepare -p /usr/local/kong && /usr/local/openresty/nginx/sbin/nginx -c /usr/local/kong/nginx.conf -p /usr/local/kong/