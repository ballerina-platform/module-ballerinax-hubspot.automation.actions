import ballerina/http;
import ballerina/test;

configurable boolean isLiveServer = true;
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/automation/v4/actions" : "http://localhost:9090";
configurable boolean isOauth = ?;
configurable string oauthKey = ?;
configurable string apiKey = ?;

int:Signed32 appId = 5712614;

// API Key Config
ConnectionConfig apikeyConfig = {
    auth: {

        hapikey: apiKey,
        private\-app\-legacy: ""
    }
};

// Client initialization
final Client hubspotAutomation = check new Client(apikeyConfig, serviceUrl);

// Sample Extension Definition
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
    objectRequestOptions: {properties: ["email"]},
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

# create Extension definition
#
# + return - error? if an error occurs, null otherwise
#
@test:Config {groups: ["apikey"]}
function testPost() returns error? {
    PublicActionDefinition response = check hubspotAutomation->/[appId].post(testingPublicActionDefinitionEgg);

    // Assert creation success and set the global ID
    test:assertTrue(response?.id is string, "Extension creation failed");

    createdExtensionId = response.id;
}

# Insert a function for a definition
#
# + return - error? if an error occurs, null otherwise
#
@test:Config {
    groups: ["apikey"],
    dependsOn: [testPost]
}
function testPostFunction() returns error? {
    PublicActionFunctionIdentifier response = check hubspotAutomation->/[appId]/[createdExtensionId]/functions/["POST_FETCH_OPTIONS"].put("exports.main = (event, callback) => {\r\n  callback({\r\n    \"options\": [{\r\n        \"label\": \"Big Widget\",\r\n        \"description\": \"Big Widget\",\r\n        \"value\": \"10\"\r\n      },\r\n      {\r\n        \"label\": \"Small Widget\",\r\n        \"description\": \"Small Widget\",\r\n        \"value\": \"1\"\r\n      }\r\n    ]\r\n  });\r\n}");

    // assert function creation success
    test:assertTrue(response?.functionType === "POST_FETCH_OPTIONS", "Function creation failed");
}

@test:Config {
    dependsOn: [testPost],
    groups: ["apikey"]
}
function testGetDefinitionById() returns error? {
    PublicActionDefinition response = check hubspotAutomation->/[appId]/[createdExtensionId];

    // Validate the retrieved extension's ID
    test:assertTrue(response?.id === createdExtensionId, "Extension retrieval failed");
}

# Get all functions for a given definition
#
# + return - error? if an error occurs, null otherwise

@test:Config {
    dependsOn: [testPostFunction],
    groups: ["apikey"]
}
function testGetAllFunctions() returns error? {
    CollectionResponsePublicActionFunctionIdentifierNoPaging response = check hubspotAutomation->/[appId]/[createdExtensionId]/functions;

    //validate the response
    test:assertTrue(response?.results.length() > 0, "No functions found for the extension");

}

# Get paged extension definitions
#
# + return - error? if an error occurs, null otherwise
#
@test:Config {groups: ["apikey"]}
function testGetPagedExtensionDefinitions() returns error? {
    CollectionResponsePublicActionDefinitionForwardPaging response = check hubspotAutomation->/[appId];

    //validate the response
    test:assertTrue(response?.results.length() > 0, "No extension definitions found");
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
    CollectionResponsePublicActionRevisionForwardPaging response = check hubspotAutomation->/[appId]/[createdExtensionId]/revisions;

    // assert response
    test:assertTrue(response?.results.length() > 0, "No revisions found for the extension");

}

# Get a revision for a given definition by revision ID
#
# + return - error? if an error occurs, null otherwise
#
@test:Config {
    dependsOn: [testPost],
    groups: ["apikey"]
}
function testGetRevision() returns error? {
    PublicActionRevision response = check hubspotAutomation->/[appId]/[createdExtensionId]/revisions/["1"];

    // assert response
    test:assertTrue(response?.revisionId === "1", "Revision retrieval failed");

}

# Archive an extension definition
#
# + return - error? if an error occurs, null otherwise
#
@test:Config {
    dependsOn: [testPost, testDeleteFunction],
    groups: ["apikey"]
}
function testDelete() returns error? {

    http:Response response = check hubspotAutomation->/[appId]/[createdExtensionId].delete();

    // assert response
    test:assertTrue(response.statusCode == 204, "Extension deletion failed");

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
    PublicActionFunction response = check hubspotAutomation->/[appId]/[createdExtensionId]/functions/["POST_ACTION_EXECUTION"];

    // validate response
    test:assertTrue(response?.functionType === "POST_ACTION_EXECUTION", "Function deletion failed");

}

# Completes a batch of callbacks
#
# + return - error? if an error occurs, null otherwise
#
@test:Config {
    groups: ["oauth"]
}
function testRespondBatch() returns error? {

    // BearerTokenConfig
    ConnectionConfig oauthConfig = {
        auth: {
            token: oauthKey
        }
    };

    final Client hubspotAutomationOauth = check new Client(oauthConfig, serviceUrl);

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

    // assert response
    test:assertTrue(response.statusCode == 204, "Batch completion failed");
}
