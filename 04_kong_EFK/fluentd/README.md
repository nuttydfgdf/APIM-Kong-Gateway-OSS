docker build -t nuttydfgdf/fluentd .

docker run --rm --name my-fluent -p 24224:24224 nuttydfgdf/fluentd

docker run -d --rm --name my-fluent -p 24224:24224 nuttydfgdf/fluentd

docker run --rm --name my-fluent -p 24224:24224 -v $(pwd)/conf/fluent.conf:/fluentd/etc/fluent.conf nuttydfgdf/fluentd

docker logs my-fluent