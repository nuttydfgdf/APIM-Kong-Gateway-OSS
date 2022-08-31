import http from 'k6/http';
import { authenticateUsingKong } from './oauth/client-credential.js';
import { check, group, sleep } from 'k6';

const CLIENT_ID = 'demo-app';
const CLIENT_SECRET = '1234';

/**
 * Option K6
 */
export let options = {
  stages: [
    { duration: '1s', target: 5 }, // simulate ramp-up of traffic from 1 to 100 users over 5 minutes.
    // { duration: '2m', target: 0 }, // ramp-down to 0 users
  ],
  insecureSkipTLSVerify: true, //Skip igone verify certificate
};

/**
 * The test setup process, in this case we need to request the api with oauth token.
 * @returns OAUth token client-credential
 */
export function setup() {
    let SCOPES = ""

    // Use either client credential authentication flow
    const passwordAuthResp = authenticateUsingKong(
        CLIENT_ID,
        CLIENT_SECRET,
        SCOPES,
    //   {
    //     username: USERNAME,
    //     password: PASSWORD,
    //   }
    );

    console.log("Using access-token : " + passwordAuthResp.access_token );

    return { resp_oauth: passwordAuthResp };
    // return passwordAuthResp;
}

export default (data) => {
    console.log(" = = = Start = = =")
    /* Log data from function Setup() is Test Setup. */
    // console.log(JSON.stringify(data.resp_oauth))

    if (!data.resp_oauth ) {
      throw new Error('incorrect data: not found access token');
    }else {
      // console.log("Using access-token : " + data.resp_oauth.access_token );
    }


    //-------------------------------------------------------------
    // Call API 
    const BASE_URL = "http://localhost:8000/httpbin/anything"

    const authHeaders = {
      headers: {
        Authorization: `Bearer ${data.resp_oauth.access_token}`,
      },
    };
  
    let res = http.get(`${BASE_URL}`, authHeaders);
    
    // console.log( JSON.stringify(res) )
  
    check(res, {
      'status is 200': (r) => r.status === 200,
    });
  
    // sleep(0.5);
  };
  
