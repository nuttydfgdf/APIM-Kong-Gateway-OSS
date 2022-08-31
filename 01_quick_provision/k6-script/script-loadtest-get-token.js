import http from 'k6/http';
import { check, group, sleep } from 'k6';
import encoding from 'k6/encoding';

export let options = {
  stages: [
    { duration: '30s', target: 25 }, // simulate ramp-up of traffic from 1 to 100 users over 5 minutes.
    // { duration: '2m', target: 0 }, // ramp-down to 0 users
  ],
  insecureSkipTLSVerify: true,
};

const BASE_URL = 'https://kong-apigw.local.net:8443/httpbin/oauth2/token';
const CLIENT_ID = 'demo-app';
const CLIENT_SECRET = '1234';

export default () => {
  const credentials = `${CLIENT_ID}:${CLIENT_SECRET}`;
  const encodedCredentials = encoding.b64encode(credentials);

  const params = {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': `Basic ${encodedCredentials}`,
      },
  };


  const payload = "grant_type=client_credentials"

  let res = http.post(BASE_URL,payload,params);

  //console.log( JSON.stringify(res) )
  // console.log("Access-token : " + res.json().access_token )

  check(res, {
    'status is 200': (r) => r.status === 200,
  });

  // sleep(0.5);
};
