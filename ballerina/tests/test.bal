import ballerina/io;
import ballerina/test;

configurable boolean isLiveServer = true;
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com" : "http://localhost:9090";
configurable boolean isOauth=?;
configurable string oauthKey=?;
configurable string apiKey=?;
int:Signed32 appId=5712614;

 // BearerTokenConfig
ConnectionConfig oauthConfig = {
    auth: {
        token:oauthKey
        }
};

  
 // API Key Config
ConnectionConfig apikeyConfig = {auth:{

    hapikey: apiKey, 
    private\-app\-legacy: ""
}};


 ConnectionConfig config = isOauth  ? oauthConfig : apikeyConfig;




// Clinet initialization
final Client hubspotAutomation = check new Client(config,serviceUrl);


// sample extension definition

string createdExtensionId = "";

FieldTypeDefinition typeDefinition = {
    referencedObjectType: "OWNER",
    externalOptions: false,
    externalOptionsReferenceType: "",
    name: "optionsInput",
    'type: "enumeration",
    fieldType: "select",
    optionsUrl: "https://webhook.site/94d09471-6f4c-4a7f-bae2-c9a585dd41e0",
    options: []
};

InputFieldDefinition inputFieldDefinition = {
    isRequired: true,
    automationFieldType: "",
    typeDefinition: typeDefinition,
    supportedValueTypes: ["STATIC_VALUE"]
};



PublicActionFunction publicActionFunction = {
    functionSource: "exports.main = (event, callback) => {\r\n  callback({\r\n    outputFields: {\r\n      myOutput: \"example output value\"\r\n    }\r\n  });\r\n}",
    functionType: "POST_ACTION_EXECUTION"
};

PublicActionDefinitionEgg testingPublicActionDefinitionEgg = {
    inputFields: [inputFieldDefinition],
    actionUrl: "https://webhook.site/94d09471-6f4c-4a7f-bae2-c9a585dd41e0",
    published: false,
    objectTypes: ["CONTACT"],
    objectRequestOptions: { properties: ["email"] },
    functions: [publicActionFunction],
    labels: {
        "en": {
            "inputFieldLabels": {
                "staticInput": "Static Input",
                "objectInput": "Object Property Input",
                "optionsInput": "External Options Input"
            },
            "actionName": "My Extension",
            "actionDescription": "My Extension Description",
            "appDisplayName": "My App Display Name",
            "actionCardContent": "My Action Card Content"
        }
    }
};



#create Extension definition
# 
# + return - error? if an error occurs, null otherwise
#
@test:Config{groups: ["apikey"]}
function testPost() returns error? {
    io:println("Testing extension creation (POST)");
    PublicActionDefinition response = check hubspotAutomation->/automation/v4/actions/[appId].post(testingPublicActionDefinitionEgg);

    // Assert creation success and set the global ID
    test:assertTrue(response?.id is string, "Extension creation failed");
    io:println("Extension created successfully with ID: ", response?.id);
    createdExtensionId = response.id;
}


# Insert a function for a definition
# 
# + return - error? if an error occurs, null otherwise
# 
@test:Config{
    groups: ["apikey"],
    dependsOn: [testPost]
}
 function testPostFunction() returns error? {
    PublicActionFunctionIdentifier response = check hubspotAutomation->/automation/v4/actions/[appId]/[createdExtensionId]/functions/["POST_FETCH_OPTIONS"].put("exports.main = (event, callback) => {\r\n  callback({\r\n    \"options\": [{\r\n        \"label\": \"Big Widget\",\r\n        \"description\": \"Big Widget\",\r\n        \"value\": \"10\"\r\n      },\r\n      {\r\n        \"label\": \"Small Widget\",\r\n        \"description\": \"Small Widget\",\r\n        \"value\": \"1\"\r\n      }\r\n    ]\r\n  });\r\n}");
}

@test:Config {
    dependsOn: [testPost],
    groups: ["apikey"]
}
function testGetDefinitionById() returns error? {
    io:println("Requesting extension by ID (GET)");
    PublicActionDefinition response = check hubspotAutomation->/automation/v4/actions/[appId]/[createdExtensionId];

    // Validate the retrieved extension's ID
    test:assertTrue(response?.id === createdExtensionId, "Extension retrieval failed");
    io:println("Extension retrieved successfully with ID: ", createdExtensionId);
}



# Get all functions for a given definition
# 
# + return - error? if an error occurs, null otherwise

@test:Config{
    dependsOn: [testPostFunction],
    groups: ["apikey"]}
 function testGetAllFunctions() returns error? {
    io:println("requesting get all functions");
    CollectionResponsePublicActionFunctionIdentifierNoPaging response = check hubspotAutomation->/automation/v4/actions/[appId]/[createdExtensionId]/functions;
    
    //validate the response
    test:assertTrue(response?.results.length() > 0, "No functions found for the extension");
    io:println("All functions retrieved successfully");    


}


# Get paged extension definitions
# 
# + return - error? if an error occurs, null otherwise
# 
@test:Config{groups: ["apikey"]}
 function testGetPagedExtensionDefinitions() returns error? {
    io:println("requesting get paged extension definitions");
    CollectionResponsePublicActionDefinitionForwardPaging response = check hubspotAutomation->/automation/v4/actions/[appId];
    //validate the response
    test:assertTrue(response?.results.length() > 0, "No extension definitions found");
    // io:println(response);
}




# Get all revisions for a given definition
# 
# + return - error? if an error occurs, null otherwise
# 
@test:Config {
    dependsOn: [testPost],
    groups: ["apikey"]
} 
function testGetAllRevisions() returns error? {
    io:println("requesting get all revisions");
    CollectionResponsePublicActionRevisionForwardPaging response = check hubspotAutomation->/automation/v4/actions/[appId]/[createdExtensionId]/revisions;
    io:println(response);
}

# Get a revision for a given definition by revision ID
# 
# + return - error? if an error occurs, null otherwise
# 
@test:Config {
    dependsOn: [testPost],
    groups: ["apikey"]
} function testGetRevision() returns error? {
    io:println("requesting get revision");
    PublicActionRevision response = check hubspotAutomation->/automation/v4/actions/[appId]/[createdExtensionId]/revisions/["1"];
    io:println(response);
}

# Archive an extension definition
# 
# + return - error? if an error occurs, null otherwise
# 
@test:Config {
    dependsOn: [testPost,testDeleteFunction],
    groups: ["apikey"]
}
 function testDelete() returns error? {
    io:println("requesting delete");
    var response = check hubspotAutomation->/automation/v4/actions/[appId]/[createdExtensionId].delete();
    io:println(response);
}


# Delete a function for a definition
# 
# + return - error? if an error occurs, null otherwise
# 
@test:Config {
    dependsOn: [testPost],
    groups: ["apikey"]
}
 function testDeleteFunction() returns error? {
    io:println("requesting delete function");
    PublicActionFunction response = check hubspotAutomation->/automation/v4/actions/[appId]/[createdExtensionId]/functions/["POST_ACTION_EXECUTION"];
    // validate response
    test:assertTrue(response?.functionType === "POST_ACTION_EXECUTION", "Function deletion failed");

}


# Completes a batch of callbacks
# 
# + return - error? if an error occurs, null otherwise
# 
@test:Config{
    groups: ["oauth"]
}
function testRespondBatch() returns error? {
    io:println("requesting respond batch");
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
    var response = check hubspotAutomation->/automation/v4/actions/callbacks/complete.post(batchCallbackCompletionRequest);
}







