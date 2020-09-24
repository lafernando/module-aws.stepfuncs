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

@test:Config {}
function testListStateMachines() returns @tainted error? {
    string taskToken = "AAAAKgAAAAIAAAAAAAAAAZdtO/NSd42ZMVMLKjH2Dw+CD+ap17EA8k2j1PHqYrW60KSdG4FMoBih+a06D7m0RNcDQ3XUOUmzD+tSkQJDiNw1eedQjsRKtJR162RktwFtCEbtAVkHPo+ig0FNdSgWoYs6ykWA1X6FEX5lWkKYrDw1PTXgfH9FzPiPDgASmtD4HnLvUUTVnStsALDQvhUc+oXpsIj6rmQO/Q4frNbkAQ850xjBkZOUEaNAwzVCjZH1n5CUxRMkIlDUe22dU5S57u0J3nMQg2NqbWj+vZvC/YFMmiSbqgSepI0HxOFFKjO9oWKSQxiQvngpWyLednY6t9uxxJm/CJkP3pKY674nNIzMTgHian8ob1XJvM86HcsKLB31Rg3cpPTD/1fL0qNUO+O36gl/GtD74u8e5XxF5J7nHa7yU2zsgOgHa52HqXWIB2EH6ZTJL6JErHc1sHdYnqvZzBl2dmJ+ipeaai5UF0Upvtr3AsyUt1mWOMs/fn2INfrPKEeBx5U3ZIcNeOmG4IRAk1xdV3rHFCbZV/hsj5GV1x11crbpFp3UCyoGOej0cX2/Xx2ewPhEDKdGlqOBWzX9hYRRUBZQ+cvhMGNSuHI=";
    check stepfuncsClient->sendTaskHeartbeat(taskToken);
    var x = check stepfuncsClient->listStateMachines();
    io:println("X:", x);
}
