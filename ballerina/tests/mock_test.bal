import ballerina/test;
import ballerina/http;
import ballerina/io;

configurable string oauthKey = "oauthKey";

# Completes a batch of callbacks
#
# + return - error? if an error occurs, null otherwise
#
@test:Config {
    groups: ["mock_tests"]
    }
function testRespondBatch() returns error? {

    // BearerTokenConfig
    ConnectionConfig oauthConfig = {
        auth: {
            token: oauthKey
        }
    };

    final Client hubspotAutomationOauth = check new Client(oauthConfig, "http://localhost:8080/mock");

    BatchInputCallbackCompletionBatchRequest batchCallbackCompletionRequest = {
        inputs: [
            {
                callbackId: "1",
                outputFields: {
                    "exampleField": "exampleValue"
                }
            }
        ]
    };
    http:Response response = check hubspotAutomationOauth->/callbacks/complete.post(batchCallbackCompletionRequest);

    io:print("Status Code ");
    io:println(response.statusCode);
    // assert response
    test:assertTrue(response.statusCode == 204, "Batch completion failed");
}
