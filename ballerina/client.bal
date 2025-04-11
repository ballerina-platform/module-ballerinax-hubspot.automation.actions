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

import ballerina/data.jsondata;
import ballerina/http;

public isolated client class Client {
    final http:Client clientEp;
    final readonly & ApiKeysConfig? apiKeyConfig;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://api.hubapi.com/automation/v4/actions") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, http1Settings: config.http1Settings, http2Settings: config.http2Settings, timeout: config.timeout, forwarded: config.forwarded, followRedirects: config.followRedirects, poolConfig: config.poolConfig, cache: config.cache, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, cookieConfig: config.cookieConfig, responseLimits: config.responseLimits, secureSocket: config.secureSocket, proxy: config.proxy, socketConfig: config.socketConfig, validation: config.validation, laxDataBinding: config.laxDataBinding};
        if config.auth is ApiKeysConfig {
            self.apiKeyConfig = (<ApiKeysConfig>config.auth).cloneReadOnly();
        } else {
            httpClientConfig.auth = <http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig>config.auth;
            self.apiKeyConfig = ();
        }
        self.clientEp = check new (serviceUrl, httpClientConfig);
    }

    # Completes a single callback
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function post callbacks/[string callbackId]/complete(CallbackCompletionRequest payload, map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/callbacks/${getEncodedUri(callbackId)}/complete`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.privateAppLegacy;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Completes a batch of callbacks
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function post callbacks/complete(BatchInputCallbackCompletionBatchRequest payload, map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/callbacks/complete`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app-legacy"] = self.apiKeyConfig?.privateAppLegacy;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Get paged extension definitions
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [int:Signed32 appId](map<string|string[]> headers = {}, *GetAppIdGetPageQueries queries) returns CollectionResponsePublicActionDefinitionForwardPaging|error {
        string resourcePath = string `/${getEncodedUri(appId)}`;
        map<anydata> queryParam = {...queries};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->get(resourcePath, headers);
    }

    # Create a new extension definition
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post [int:Signed32 appId](PublicActionDefinitionEgg payload, map<string|string[]> headers = {}) returns PublicActionDefinition|error {
        string resourcePath = string `/${getEncodedUri(appId)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Get all functions for a given definition
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get [int:Signed32 appId]/[string definitionId]/functions(map<string|string[]> headers = {}) returns CollectionResponsePublicActionFunctionIdentifierNoPaging|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/functions`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->get(resourcePath, headers);
    }

    # Get all functions by a type for a given definition
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get [int:Signed32 appId]/[string definitionId]/functions/["PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType](map<string|string[]> headers = {}) returns PublicActionFunction|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/functions/${getEncodedUri(functionType)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->get(resourcePath, headers);
    }

    # Insert a function for a definition
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function put [int:Signed32 appId]/[string definitionId]/functions/["PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType](string payload, map<string|string[]> headers = {}) returns PublicActionFunctionIdentifier|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/functions/${getEncodedUri(functionType)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        request.setPayload(payload, "text/plain");
        return self.clientEp->put(resourcePath, request, headers);
    }

    # Delete a function for a definition
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete [int:Signed32 appId]/[string definitionId]/functions/["PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType](map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/functions/${getEncodedUri(functionType)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Gets a revision for a given definition by revision id
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get [int:Signed32 appId]/[string definitionId]/revisions/[string revisionId](map<string|string[]> headers = {}) returns PublicActionRevision|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/revisions/${getEncodedUri(revisionId)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->get(resourcePath, headers);
    }

    # Get extension definition by Id
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [int:Signed32 appId]/[string definitionId](map<string|string[]> headers = {}, *GetAppIdDefinitionIdGetByIdQueries queries) returns PublicActionDefinition|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}`;
        map<anydata> queryParam = {...queries};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->get(resourcePath, headers);
    }

    # Archive an extension definition
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete [int:Signed32 appId]/[string definitionId](map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Patch an existing extension definition
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function patch [int:Signed32 appId]/[string definitionId](PublicActionDefinitionPatch payload, map<string|string[]> headers = {}) returns PublicActionDefinition|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, headers);
    }

    # Get a function for a given definition
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get [int:Signed32 appId]/[string definitionId]/functions/["PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType]/[string functionId](map<string|string[]> headers = {}) returns PublicActionFunction|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/functions/${getEncodedUri(functionType)}/${getEncodedUri(functionId)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->get(resourcePath, headers);
    }

    # Insert a function for a definition
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function put [int:Signed32 appId]/[string definitionId]/functions/["PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType]/[string functionId](string payload, map<string|string[]> headers = {}) returns PublicActionFunctionIdentifier|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/functions/${getEncodedUri(functionType)}/${getEncodedUri(functionId)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        http:Request request = new;
        request.setPayload(payload, "text/plain");
        return self.clientEp->put(resourcePath, request, headers);
    }

    # Archive a function for a definition
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete [int:Signed32 appId]/[string definitionId]/functions/["PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType]/[string functionId](map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/functions/${getEncodedUri(functionType)}/${getEncodedUri(functionId)}`;
        map<anydata> queryParam = {};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Get all revisions for a given definition
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [int:Signed32 appId]/[string definitionId]/revisions(map<string|string[]> headers = {}, *GetAppIdDefinitionIdRevisionsGetPageQueries queries) returns CollectionResponsePublicActionRevisionForwardPaging|error {
        string resourcePath = string `/${getEncodedUri(appId)}/${getEncodedUri(definitionId)}/revisions`;
        map<anydata> queryParam = {...queries};
        if self.apiKeyConfig is ApiKeysConfig {
            queryParam["hapikey"] = self.apiKeyConfig?.hapikey;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queryParam);
        return self.clientEp->get(resourcePath, headers);
    }
}
