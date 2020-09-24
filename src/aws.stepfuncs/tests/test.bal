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
    string taskToken = "AAAAKgAAAAIAAAAAAAAAAShYmJk12R4Wf8bQm1l62o3ixKi9b2bkPEC9Zc4fAbBDSk+dNvFMgtEED20ZE1Kl31tZoTHB7xrZncglyztlpbn8zXt33pREe47JdNErDXP9OTT9NobokRd5c4TONpY0qluloaUW55hhuRPDctBSB+oYMRa/IxajulAiNCH58nrNENVOff1KfHqatw3/9RnWuA6uL56RHSs5+yAQaEg2/n7tzmrF30gSxeKHeoGaPiSKYaSyfwHbUXLgsmvzUkjxmIVPybXCGAkRmFancgZwFQohfq86NuffjWCjjU+5VNY+vuT6r6dJ+HOFX6S5W9Geaj5pVdzfz40lQGOYDvej6herx5dgfgea9lMz/lPbzDE8fygRryNcJa6N5bAK4Cdn4KlhcpoJg66AMdNeUKINVJfmO+G6HEg8OIe8GCF1nky4FzahRZCvGrt/9zOq4uC36zm2soa7TlJMXEE/K8mX3oB0txDfgPLqgtd0FElCQkA5wqbP8+83dZcRuQugFk1UKzO1BQ/QhoXZfCZ8ZhrEsYEXwnbNz8mKWA0foj4Mkx3uz/5gIp11HgNcq5mXCda+m0zUVcrZFxVoNNZPX+URRaI=";
    check stepfuncsClient->sendTaskFailure("c1", "e1", taskToken);
    var x = check stepfuncsClient->listStateMachines();
    io:println("X:", x);
}
