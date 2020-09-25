# Ballerina AWS Step Functions Connector

This connector allows to use the AWS Step Functions service through Ballerina. The operations mirror the API at https://docs.aws.amazon.com/step-functions/latest/apireference/API_Operations.html.

## Compatibility
| Ballerina Language Version 
| -------------------------- 
| 1.2.x                    


The following sections provide you with information on how to use the AWS Step Functions Service Connector.

- [Contribute To Develop](#contribute-to-develop)
- [Working with AWS Step Functions Service Connector actions](#working-with-amazon-rekognition-service-connector)
- [Sample](#sample)

### Contribute To develop

Clone the repository by running the following command 
```shell
git clone https://github.com/lafernando/module-aws.stepfuncs
```

### Working with AWS Step Functions Service Connector

First, import the `laf/aws.stepfuncs` module into the Ballerina project.

```ballerina
import laf/aws.stepfuncs;
```

In order for you to use the AWS Step Functions Service Connector, first you need to create an AWS Step Functions Service Connector client.

```ballerina
stepfuncs:Configuration config = {
    accessKey: config:getAsString("ACCESS_KEY"),
    secretKey: config:getAsString("SECRET_KEY"),
    region: "us-west-1"
};

stepfuncs:Client sfnClient = new(config);
```

##### Sample

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
    var startExResult = check stepfuncsClient->startExecution(sms[0].stateMachineArn, { msg: "Hi" });
    io:println("Start Exec: ", startExResult);
    var sendTaskSuccessResult = stepfuncsClient->sendTaskSuccess("task_id", { status: 1000 });
    io:println("Send Task Success: ", sendTaskSuccessResult);
    var stopExResult = check stepfuncsClient->stopExecution(startExResult.executionArn);
    io:println("Stop Exec: ", stopExResult);
}
```
