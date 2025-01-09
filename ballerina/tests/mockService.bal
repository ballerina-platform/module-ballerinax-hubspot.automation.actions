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
