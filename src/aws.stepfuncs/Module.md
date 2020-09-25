Connects to AWS Step Functions service. The operations mirror the API at https://docs.aws.amazon.com/step-functions/latest/apireference/API_Operations.html.

# Module Overview

## Compatibility
| Ballerina Language Version 
| -------------------------- 
| 1.2.x

## Sample

```ballerina
import ballerina/config;
import laf/aws.stepfuncs;
import ballerina/io;

stepfuncs:Configuration config = {
    accessKey: config:getAsString("ACCESS_KEY"),
    secretKey: config:getAsString("SECRET_KEY"),
    region: "us-west-1"
};

stepfuncs:Client stepfuncsClient = new(config);

public function main() returns error? {
    stepfuncs:StateMachineListItem[] sms = check stepfuncsClient->listStateMachines();
    io:println("State Machines:", sms);
    var startExResult = check stepfuncsClient->startExecution(
                              sms[0].stateMachineArn, { msg: "Hi" });
    io:println("Start Exec: ", startExResult);
    var sendTaskSuccessResult = stepfuncsClient->sendTaskSuccess("task_id", 
                                { status: 1000 });
    io:println("Send Task Success: ", sendTaskSuccessResult);
    var stopExResult = check stepfuncsClient->stopExecution(
                             startExResult.executionArn);
    io:println("Stop Exec: ", stopExResult);
}
```
