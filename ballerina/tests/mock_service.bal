// import ballerina/http;
// import ballerina/log;
// import ballerina/test;

// configurable int port = 9091;
// listener http:Listener httpListener = new (port);

// http:Service mockService = service  object {
//     resource function post callbacks/complete(http:Caller caller, http:Request req) returns error? {
//         log:printInfo("Received request for batch completion");

//         // Mock response
//         http:Response res = new;
//         res.statusCode = 204;
//         check caller->respond(res);
//     };
// };

// @test:BeforeSuite
//  function init() returns error? {
//     // Start the mock service
//     check httpListener.attach(mockService ,"/mock");
//     check httpListener.'start();
    
// };

// @test:AfterSuite
// function dispose() returns error? {
    
//     check httpListener.gracefulStop();
//     check httpListener.detach(mockService);
// };
