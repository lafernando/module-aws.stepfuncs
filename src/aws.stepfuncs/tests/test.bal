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
import ballerina/config;
import ballerina/test;
import ballerina/io;

Configuration config = {
    accessKey: config:getAsString("ACCESS_KEY"),
    secretKey: config:getAsString("SECRET_KEY"),
    region: "us-west-1"
};

Client stepfuncsClient = new(config);

//@test:Config { }
function testListStateMachines() returns @tainted error? {
    _ = check stepfuncsClient->listStateMachines();
}

//@test:Config { }
function testSendTaskSuccess() returns @tainted error? {
    string taskToken = "AAAAKgAAAAIAAAAAAAAAAXjsdNgCPnPecALZ/q/MsjQNwnAtAlntRQxQOpfYkxjVryRSjaGbEGSw90eHFj5xCi6kfmaLnnppx7R8rTGIk9S1ASJW/mpb0Y2GB6eNUdUqNR4ewZvijcBNxB+JeTHuLeCJHGPj3UeDlgFOzQNn2w0LpRRSu4pf4RP2QY/h6vvmjg1a18gbLHuQWZBFPAoK6y3Kp8MD0k9WMBm9qlJZAm9LXv16DWxJo/Q24OjlKVzWjv8EY5aZKDs3RcF3U2IWGPtWs/B9mqr1+kvwNpJF8R6r+hF/myuqxKVnB3Rr6AcOqS5YhW8L3NOxxRPUOUKAce7tkw51AqU3ul/5E8Yi6dtjsmVTJZQlxevKpM3VtQQTT691CTtezbyvH8GEjQ/Jxozp0tHGtgHrCSi3TY6clf+qgS63kUgP0rLduTXPGOwNwPhDS53qBfGgvG7klwUDLoZV2FCVDXmrcThTBV8Eg4koyj7cvgb5a+LKwXAHZzoY+DtjZ+4gh3qhq3f0/M/IOiCWZMjS24u1cxsyjmuA9F2ouUWpnqoJeE6r4vrhSDDNlWVnmRmPbPRFiypvKX4yPogg7KgQyJDh+sniigUWj+Q=";
    check stepfuncsClient->sendTaskSuccess({}, taskToken);
}

//@test:Config { }
function testStartExecution() returns @tainted error? {
    string stateMachineArn = "arn:aws:states:us-west-1:908363916138:stateMachine:MyStateMachine";
    var result = check stepfuncsClient->startExecution({msg: "Hi"}, (), stateMachineArn, ());
    io:println("Start Exec: ", result);
}

//@test:Config { }
function testStopExecution() returns @tainted error? {
    string stateMachineArn = "arn:aws:states:us-west-1:908363916138:execution:MyStateMachine:01d3e7cc-c1fb-437e-9f86-5c35ec6a3463";
    var result = check stepfuncsClient->stopExecution("My Error", (), stateMachineArn);
    io:println("Stop Exec: ", result);
}