# Create Kong API Loopback
curl -X POST http://127.0.0.1:8001/services \
  --data name=admin-api \
  --data host=127.0.0.1 \
  --data port=8001

curl -X POST http://127.0.0.1:8001/services/admin-api/routes \
  --data paths[]=/admin-api

# Open Konga UI

KONG ADMIN URL
http://kong-gateway:8000/admin-api


# Postgres Command
Go to inside container 
```
docker exec -it kong-database bash
psql -U konguser -d db_kong
postgres=# \dt

# Postgress command
\q To exit
\l list of database
\dt show all tables
\c ${dbname} : switch database
```


