https://docs.konghq.com/hub/
\### Plugin status

- [x] Basic Authentication
- [ ] HMAC Authentication
- [x] JWT
- [x] Key Authentication
- [ ] OAuth 2.0 Authentication
- [ ] LDAP Authentication
- [ ] Session


docker-compose up -d --force-recreate

# Check Route 
http://localhost:8001/routes


# Test Basic Auth
curl -u user:pass http://xxx

curl -u nutsu:1234 http://localhost:8000/httpbin/basic-auth/ip

# Test Key Auth (API-Key)
Make a request with the key in a header:
```
$ curl http://localhost:8000/httpbin/key-auth

Output
{
  "message":"No API key found in request"
}
```

```
$ curl http://localhost:8000/httpbin/key-auth/ip \
    -H 'apikey: 32c130e3-8289-480b-a3e3-d5695de38830'

output
{
  "origin": "172.18.0.1, 171.97.97.30"
}
```

# Test JWT
First step config Key, In this case we use declarative file.
https://cryptotools.net/rsagen
```
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7VJTUt9Us8cKj
MzEfYyjiWA4R4/M2bS1GB4t7NXp98C3SC6dVMvDuictGeurT8jNbvJZHtCSuYEvu
NMoSfm76oqFvAp8Gy0iz5sxjZmSnXyCdPEovGhLa0VzMaQ8s+CLOyS56YyCFGeJZ
qgtzJ6GR3eqoYSW9b9UMvkBpZODSctWSNGj3P7jRFDO5VoTwCQAWbFnOjDfH5Ulg
p2PKSQnSJP3AJLQNFNe7br1XbrhV//eO+t51mIpGSDCUv3E0DDFcWDTH9cXDTTlR
ZVEiR2BwpZOOkE/Z0/BVnhZYL71oZV34bKfWjQIt6V/isSMahdsAASACp4ZTGtwi
VuNd9tybAgMBAAECggEBAKTmjaS6tkK8BlPXClTQ2vpz/N6uxDeS35mXpqasqskV
laAidgg/sWqpjXDbXr93otIMLlWsM+X0CqMDgSXKejLS2jx4GDjI1ZTXg++0AMJ8
sJ74pWzVDOfmCEQ/7wXs3+cbnXhKriO8Z036q92Qc1+N87SI38nkGa0ABH9CN83H
mQqt4fB7UdHzuIRe/me2PGhIq5ZBzj6h3BpoPGzEP+x3l9YmK8t/1cN0pqI+dQwY
dgfGjackLu/2qH80MCF7IyQaseZUOJyKrCLtSD/Iixv/hzDEUPfOCjFDgTpzf3cw
ta8+oE4wHCo1iI1/4TlPkwmXx4qSXtmw4aQPz7IDQvECgYEA8KNThCO2gsC2I9PQ
DM/8Cw0O983WCDY+oi+7JPiNAJwv5DYBqEZB1QYdj06YD16XlC/HAZMsMku1na2T
N0driwenQQWzoev3g2S7gRDoS/FCJSI3jJ+kjgtaA7Qmzlgk1TxODN+G1H91HW7t
0l7VnL27IWyYo2qRRK3jzxqUiPUCgYEAx0oQs2reBQGMVZnApD1jeq7n4MvNLcPv
t8b/eU9iUv6Y4Mj0Suo/AU8lYZXm8ubbqAlwz2VSVunD2tOplHyMUrtCtObAfVDU
AhCndKaA9gApgfb3xw1IKbuQ1u4IF1FJl3VtumfQn//LiH1B3rXhcdyo3/vIttEk
48RakUKClU8CgYEAzV7W3COOlDDcQd935DdtKBFRAPRPAlspQUnzMi5eSHMD/ISL
DY5IiQHbIH83D4bvXq0X7qQoSBSNP7Dvv3HYuqMhf0DaegrlBuJllFVVq9qPVRnK
xt1Il2HgxOBvbhOT+9in1BzA+YJ99UzC85O0Qz06A+CmtHEy4aZ2kj5hHjECgYEA
mNS4+A8Fkss8Js1RieK2LniBxMgmYml3pfVLKGnzmng7H2+cwPLhPIzIuwytXywh
2bzbsYEfYx3EoEVgMEpPhoarQnYPukrJO4gwE2o5Te6T5mJSZGlQJQj9q4ZB2Dfz
et6INsK0oG8XVGXSpQvQh3RUYekCZQkBBFcpqWpbIEsCgYAnM3DQf3FJoSnXaMhr
VBIovic5l0xFkEHskAjFTevO86Fsz1C2aSeRKSqGFoOQ0tmJzBEs1R6KqnHInicD
TQrKhArgLXX4v3CddjfTRJkFWDbE/CkvKZNOrcf1nhaGCPspRJj2KUkj1Fhl9Cnc
dn/RsYEONbwQSjIfMPkvxF+8HQ==
-----END PRIVATE KEY-----
```
```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo
4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u
+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh
kd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ
0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg
cKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc
mwIDAQAB
-----END PUBLIC KEY-----
```

List JWT credentials
You can list a Consumer’s JWT credentials by issuing the following HTTP request:
```
$ curl -X GET http://kong:8001/consumers/{consumer}/jwt
curl -X GET http://localhost:8001/consumers/nutsu/jwt

output
{
	"next": null,
	"data": [{
			"secret": "1234",
			"algorithm": "RS256",
			"key": "AaBbCc",
			"tags": null,
			"consumer": {
				"id": "7f26c409-9ac7-57f0-984a-addbe907a0e1"
			},
			"id": "71332ecb-5b7f-5db9-bbe4-122860a585e8",
			"rsa_public_key": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo\n4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u\n+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh\nkd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ\n0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg\ncKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc\nmwIDAQAB\n-----END PUBLIC KEY-----",
			"created_at": 1643944689
		}
	]
}
```

Curl Proxy
```
curl http://localhost:8000/httpbin/jwt/ip

output
{"message":"Unauthorized"}
```



https://docs.konghq.com/hub/kong-inc/jwt/#craft-a-jwt-with-publicprivate-keys-rs256-or-es256

Using the JWT debugger at https://jwt.io
When creating the signature, make sure that the header is:
```
{
    "typ": "JWT",
    "alg": "RS256"
}
```
Secondly, the claims must contain the secret’s key field (this isn’t your private key used to generate the token, but just an identifier for this credential) in the configured claim (from config.key_claim_name). That claim is iss (issuer field) by default. Set its value to our previously created credential’s key. The claims may contain other values. Since Kong version 0.13.1, the claim is searched in both the JWT payload and header, in that order.
```
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true,
  "iat": 1516239022,
  "iss": "AaBbCc" // ref. jwt_secrets: .key
}
```

Copy the encryption token in https://jwt.io/ and trying to call api proxy

```
$ curl http://localhost:8000/httpbin/jwt/ip \
    -H 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMiwiaXNzIjoiQWFCYkNjIn0.nJ3X-8oLSuW-uqQIi-H147SYi_I5IPa7U-7JPpsypzj1wUj8wk4aFC3lmHWJrPmKHxZXNi9fd6lLrJ-SJnf5S6IUGb6rvTmXn6j3drfXcaLyo_-plbe_53j4wH6PiXwVcUJLXSxZ0WR---EFx2DoFpbSOVg4yOAhO5AMw2Usj_VglJAvmhl8rEr5ZehHNGJyIeKqQGQpgXZRAGETKXgETo84sihYQWN9Sp0j6hIuOhhywHpb1aJbPbcLuP0Iftoi3toiDUXNXaeg1eZl8QiWbwueLAoFLMRK61ys-4Mx3L-NAGdmu5qOxpvG99OR-cUlbhyxCnbs7KoRgKifJePcYA'

output
{
  "origin": "172.18.0.1, 171.97.97.30"
}
```