// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
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
import ballerina/test;

service /mock on new http:Listener(8080) {

    resource function post callbacks/complete(http:Caller caller, http:Request req) returns error? {

        // Mock response
        http:Response res = new;
        res.statusCode = 204;
        check caller->respond(res);
    };
}

@test:BeforeSuite
function startMockService() {
    // Code to start the mock service
    // This is automatically handled by Ballerina when the service is defined

}

@test:AfterSuite
function stopMockService() {
    // Code to stop the mock service
    // This is automatically handled by Ballerina when the service is defined

}
