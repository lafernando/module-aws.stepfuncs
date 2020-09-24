// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/http;
import ballerina/time;
import wso2/amazoncommons;

# Object to initialize the connection with AWS Step Functions Service.
#
# + accessKey - The Amazon API access key
# + secretKey - The Amazon API secret key
public type Client client object {

    http:Client clientEp;
    string accessKey;
    string secretKey;
    string region;

    public function __init(Configuration config) {
        self.accessKey = config.accessKey;
        self.secretKey = config.secretKey;
        self.region = config.region;
        self.clientEp = new("https://" + STEPFUNCS_SERVICE_NAME + "." + self.region + "." + amazoncommons:AMAZON_HOST);
    }

    function execAction(string accessKey, string secretKey, string region, string action,
                            string payload) returns @tainted string|error? {
        string host = STEPFUNCS_SERVICE_NAME + "." + region + "." + amazoncommons:AMAZON_HOST;
        time:Time time = check time:toTimeZone(time:currentTime(), "GMT");
        string amzdate = amazoncommons:generateAmzdate(time);
        string datestamp = amazoncommons:generateDatestamp(time);

        map<string> headers = {};
        headers["Content-Type"] = STEPFUNCS_CONTENT_TYPE;
        headers["Host"] = host;
        headers["X-Amz-Date"] = amzdate;
        headers["X-Amz-Target"] = "AWSStepFunctions." + action;

        amazoncommons:populateAuthorizationHeaders(accessKey, secretKey, region, STEPFUNCS_SERVICE_NAME, payload, "/", 
                                                   "", headers, "POST", amzdate, datestamp);

        http:Request request = new;
        request.setTextPayload(payload);
        foreach var [k,v] in headers.entries() {
            request.setHeader(k, v);
        }
        var httpResponse = check self.clientEp->post("/", request);
        if httpResponse.statusCode != http:STATUS_OK {
            string err = <@untainted> check httpResponse.getTextPayload();
            return error(err);
        }
        return <@untainted> check httpResponse.getTextPayload();
    }

    public remote function sendTaskSuccess(json output, string taskToken) returns @tainted error? {
        json payload = { output: output, taskToken: taskToken };
        _ = check self.execAction(self.accessKey, self.secretKey, self.region, "SendTaskSuccess",
                                  payload.toJsonString());
    }

    public remote function sendTaskHeartbeat(string taskToken) returns @tainted error? {
        json payload = { taskToken: taskToken };
        _ = check self.execAction(self.accessKey, self.secretKey, self.region, "SendTaskHeartbeat",
                                  payload.toJsonString());
    }

    public remote function sendTaskFailure(string cause, string err, string taskToken) returns @tainted error? {
        json payload = { cause: cause, 'error: err, taskToken: taskToken };
        _ = check self.execAction(self.accessKey, self.secretKey, self.region, "SendTaskFailure",
                                  payload.toJsonString());
    }

    public remote function listStateMachines() returns @tainted json|error? {
        json payload = { };
        return check self.execAction(self.accessKey, self.secretKey, self.region, "ListStateMachines",
                                     payload.toJsonString());
    }

};

# AWS Step Functions Service configuration.
#
# + accessKey - The Amazon access key
# + secretKey - The Amazon secret key
# + region    - The Amazon region
public type Configuration record {
    string accessKey;
    string secretKey;
    string region = amazoncommons:DEFAULT_REGION;
};


