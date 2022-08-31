import http from 'k6/http';
import encoding from 'k6/encoding';

const BASE_URL = 'https://kong-apigw.local.net:8443/httpbin/oauth2/token';

/**
 * Authenticate using OAuth against Kong Client Credential
 * @function
 * @param  {string} clientId - Application ID in Azure
 * @param  {string} clientSecret - Can be obtained from https://docs.microsoft.com/en-us/azure/storage/common/storage-auth-aad-app#create-a-client-secret
 * @param  {string} scope - Space-separated list of scopes (permissions) that are already given consent to by admin
 * @param  {string} resource - Either a resource ID (as string) or an object containing username and password
 */
export function authenticateUsingKong(clientId, clientSecret, scope, resource) {
  let url;

  const credentials = `${clientId}:${clientSecret}`;
  const encodedCredentials = encoding.b64encode(credentials);

  const params = {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': `Basic ${encodedCredentials}`,
      },
  };

  const payload = "grant_type=client_credentials"

  const response = http.post(BASE_URL, payload, params);

  //Log response
//   console.log( JSON.stringify(res) )
  // console.log("Access-token : " + res.json().access_token )

  return response.json();
}
