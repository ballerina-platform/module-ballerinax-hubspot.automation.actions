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

configurable boolean isLiveServer =?;
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
final Client hubspotAutomation = check new Client(apikeyConfig, "https://api.hubapi.com/automation/v4/actions");

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
            inputFieldLabels: {
                "staticInput": "Static Input",
                "objectInput": "Object Property Input",
                "optionsInput": "External Options Input"
            },
            actionName: "My Extension",
            actionDescription: "My Extension Description",
            appDisplayName: "My App Display Name",
            actionCardContent: "My Action Card Content"
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
    test:assertEquals(response?.functions[0]?.functionType, "POST_ACTION_EXECUTION", "Function type mismatch");
    test:assertEquals(response?.functions[1]?.functionType, "POST_FETCH_OPTIONS", "Function type mismatch");
    test:assertEquals(response?.actionUrl, "https://webhook.site/94d09471-6f4c-4a7f-bae2-c9a585dd41e0", "Action URL mismatch");
    test:assertEquals(response?.published, false, "Published status mismatch");
    test:assertEquals(response?.labels["en"]?.appDisplayName, "My App Display Name", "App display name mismatch");
    test:assertEquals(response?.labels["en"]?.actionDescription, "My Extension Description", "Action description mismatch");
    test:assertEquals(response?.labels["en"]?.inputFieldLabels["optionsInput"], "External Options Input", "Input field label mismatch");
    test:assertEquals(response?.labels["en"]?.actionName, "My Extension", "Action name mismatch");
    test:assertEquals(response?.labels["en"]?.actionCardContent, "My Action Card Content", "Action card content mismatch");
    test:assertEquals(response?.inputFields[0]?.isRequired, true, "Input field required status mismatch");
    test:assertEquals(response?.inputFields[0]?.typeDefinition?.referencedObjectType, "OWNER", "Referenced object type mismatch");
    test:assertEquals(response?.inputFields[0]?.typeDefinition?.name, "optionsInput", "Input field name mismatch");
    test:assertEquals(response?.inputFields[0]?.typeDefinition?.optionsUrl, "https://webhook.site/94d09471-6f4c-4a7f-bae2-c9a585dd41e0", "Options URL mismatch");
    test:assertEquals(response?.revisionId, "1", "Revision ID mismatch");
    test:assertEquals(response?.objectTypes[0], "0-1", "Object type mismatch");

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
    test:assertEquals(response?.definition?.actionUrl, "https://webhook.site/94d09471-6f4c-4a7f-bae2-c9a585dd41e0", "Action URL mismatch");
    test:assertEquals(response?.definition?.published, false, "Published status mismatch");
    test:assertEquals(response?.definition?.inputFields[0]?.typeDefinition?.referencedObjectType, "OWNER", "Referenced object type mismatch");
    test:assertEquals(response?.definition?.inputFields[0]?.typeDefinition?.fieldType, "select", "Field type mismatch");
    test:assertEquals(response?.definition?.inputFields[0]?.typeDefinition?.optionsUrl, "https://webhook.site/94d09471-6f4c-4a7f-bae2-c9a585dd41e0", "Options URL mismatch");
    test:assertEquals(response?.definition?.revisionId, "1", "Revision ID mismatch");

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
    test:assertTrue(response?.functionSource== "exports.main = (event, callback) => {\r\n  callback({\r\n    outputFields: {\r\n      myOutput: \"example output value\"\r\n    }\r\n  });\r\n}", "Function deletion failed");

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
    string serviceUrl = isLiveServer ? "https://api.hubapi.com/automation/v4/actions" : "http://localhost:8080/mock";

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
