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
# The operations mirror the API at https://docs.aws.amazon.com/step-functions/latest/apireference/API_Operations.html. 
#
# + accessKey - The AWS API access key
# + secretKey - The AWS API secret key
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
                        string payload) returns string|error {
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
        var result = <@untainted> httpResponse.getTextPayload();
        if result is error {
            return result;
        } else {
            if httpResponse.statusCode != http:STATUS_OK {
                return error(result);
            } else {
                return result;
            }
        }
    }

    public remote function sendTaskSuccess(string taskToken, json output) returns error? {
        json payload = { output: output.toJsonString(), taskToken: taskToken };
        _ = check self.execAction(self.accessKey, self.secretKey, self.region, "SendTaskSuccess",
                                  payload.toJsonString());
    }

    public remote function sendTaskHeartbeat(string taskToken) returns error? {
        json payload = { taskToken: taskToken };
        _ = check self.execAction(self.accessKey, self.secretKey, self.region, "SendTaskHeartbeat",
                                  payload.toJsonString());
    }

    public remote function sendTaskFailure(string taskToken, string? cause = (), string? err = ()) returns error? {
        json payload = { cause: cause, 'error: err, taskToken: taskToken };
        _ = check self.execAction(self.accessKey, self.secretKey, self.region, "SendTaskFailure",
                                  payload.toJsonString());
    }

    public remote function listStateMachines() returns StateMachineListItem[]|error {
        json payload = { };
        string result = check self.execAction(self.accessKey, self.secretKey, self.region, "ListStateMachines",
                                            payload.toJsonString());
        json jr = check result.fromJsonString();
        return StateMachineListItem[].constructFrom(check jr.stateMachines);
    }

    public remote function startExecution(string stateMachineArn, json input, string? name = (), 
                                          string? traceHeader = ()) returns StartExecResult|error {
        json payload = { input: input.toJsonString(), name: name, stateMachineArn: stateMachineArn, 
                         traceHeader: traceHeader };
        string result = check self.execAction(self.accessKey, self.secretKey, self.region, "StartExecution",
                                              payload.toJsonString());
        return StartExecResult.constructFrom(check result.fromJsonString());
    }

    public remote function stopExecution(string executionArn, string? cause = (), string? err = ()) 
                                         returns StopExecResult|error {
        json payload = { cause: cause, 'error: err, executionArn: executionArn };
        string result = check self.execAction(self.accessKey, self.secretKey, self.region, "StopExecution",
                                              payload.toJsonString());
        return StopExecResult.constructFrom(check result.fromJsonString());                                        
    }

};

# AWS Step Functions Service configuration.
#
# + accessKey - The AWS access key
# + secretKey - The AWS secret key
# + region    - The AWS region
public type Configuration record {
    string accessKey;
    string secretKey;
    string region = amazoncommons:DEFAULT_REGION;
};


