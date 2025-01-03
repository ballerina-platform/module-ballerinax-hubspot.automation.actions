import ballerinax/hubspot.automation.actions;
import ballerina/http;

configurable string oauthKey = ?;

public function main() returns error? {
    // BearerTokenConfig
    actions:ConnectionConfig oauthConfig = {
        auth: {
            token: oauthKey
        }
    };

    final actions:Client automationClient = check new actions:Client(oauthConfig);

    actions:BatchInputCallbackCompletionBatchRequest batchCallbackCompletionRequest = {
        inputs: [
            {
                callbackId: "1",
                outputFields: {
                    "exampleField": "exampleValue"
                }
            }
        ]
    };
    http:Response response= check automationClient->/callbacks/complete.post(batchCallbackCompletionRequest);

}
