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

import ballerina/io;
import ballerinax/hubspot.automation.actions;
import ballerina/http;

configurable string apiKey = ?;

public function main() returns error? {

    // Developer API Key Config
    actions:ConnectionConfig apikeyConfig = {
        auth: {

            hapikey: apiKey,
            private\-app\-legacy: ""
        }
    };

    // Client initialization   
    final actions:Client hubspotAutomation = check new actions:Client(apikeyConfig);

    // sample extension definition
    string createdExtensionId = "";
    int:Signed32 appId = 5712614;

    actions:FieldTypeDefinition typeDefinition = {
        referencedObjectType: "OWNER",
        externalOptions: false,
        externalOptionsReferenceType: "",
        name: "optionsInput",
        'type: "enumeration",
        fieldType: "select",
        optionsUrl: "https://webhook.site/94d09471-6f4c-4a7f-bae2-c9a585dd41e0",
        options: []
    };

    actions:InputFieldDefinition inputFieldDefinition = {
        isRequired: true,
        automationFieldType: "",
        typeDefinition: typeDefinition,
        supportedValueTypes: ["STATIC_VALUE"]
    };

    actions:PublicActionFunction publicActionFunction = {
        functionSource: "exports.main = (event, callback) => {\r\n  callback({\r\n    outputFields: {\r\n      myOutput: \"example output value\"\r\n    }\r\n  });\r\n}",
        functionType: "POST_ACTION_EXECUTION"
    };

    actions:PublicActionDefinitionEgg testingPublicActionDefinitionEgg = {
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

    // Create Extension
    actions:PublicActionDefinition response = check hubspotAutomation->/[appId].post(testingPublicActionDefinitionEgg);
    createdExtensionId = response.id;
    io:println("Extension Created with ID: " + createdExtensionId);

    // Get Extension
    actions:PublicActionDefinition getResponse = check hubspotAutomation->/[appId]/[createdExtensionId].get();
    io:println("Extension Retrieved: " + getResponse.id);

    // Update Extension
    actions:PublicActionDefinition updateResponse = check hubspotAutomation->/[appId]/[createdExtensionId];
    io:println("Extension Updated: ");
    io:println(updateResponse);

    // Delete Extension
    http:Response deleteResponse = check hubspotAutomation->/[appId]/[createdExtensionId].delete();
    io:println("Extension Deleted");

}
