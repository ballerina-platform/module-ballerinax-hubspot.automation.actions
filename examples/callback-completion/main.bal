import ballerinax/hubspot.automation.actions;

configurable string oauthKey=?;
public function main() returns error? {
     // BearerTokenConfig
   actions:ConnectionConfig oauthConfig = {
        auth: {
            token:oauthKey
            }};
            
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
    var response = check automationClient->/automation/v4/actions/callbacks/complete.post(batchCallbackCompletionRequest);
    
}