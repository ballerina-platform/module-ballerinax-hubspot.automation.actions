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

public type PublicActionFunction record {
    string functionSource;
    "PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType;
    string id?;
};

public type PublicActionDefinition record {
    PublicActionFunctionIdentifier[] functions;
    string actionUrl;
    boolean published;
    record {|PublicActionLabels...;|} labels;
    InputFieldDefinition[] inputFields;
    OutputFieldDefinition[] outputFields?;
    string revisionId;
    int archivedAt?;
    PublicActionDefinitionInputFieldDependencies[] inputFieldDependencies?;
    PublicExecutionTranslationRule[] executionRules?;
    string id;
    string[] objectTypes;
    PublicObjectRequestOptions objectRequestOptions?;
};

public type PublicConditionalSingleFieldDependency record {
    "CONDITIONAL_SINGLE_FIELD" dependencyType = "CONDITIONAL_SINGLE_FIELD";
    string controllingFieldName;
    string controllingFieldValue;
    string[] dependentFieldNames;
};

public type PublicActionDefinitionInputFieldDependencies PublicSingleFieldDependency|PublicConditionalSingleFieldDependency;

public type PublicObjectRequestOptions record {
    string[] properties;
};

public type PublicActionLabels record {
    record {|string...;|} inputFieldDescriptions?;
    string appDisplayName?;
    record {|string...;|} outputFieldLabels?;
    record {|record {|string...;|}...;|} inputFieldOptionLabels?;
    string actionDescription?;
    record {|string...;|} executionRules?;
    record {|string...;|} inputFieldLabels?;
    string actionName;
    string actionCardContent?;
};

public type PublicSingleFieldDependency record {
    "SINGLE_FIELD" dependencyType = "SINGLE_FIELD";
    string controllingFieldName;
    string[] dependentFieldNames;
};

public type ForwardPaging record {
    NextPage next?;
};

public type FieldTypeDefinition record {
    string helpText?;
    "CONTACT"|"COMPANY"|"DEAL"|"ENGAGEMENT"|"TICKET"|"OWNER"|"PRODUCT"|"LINE_ITEM"|"BET_DELIVERABLE_SERVICE"|"CONTENT"|"CONVERSATION"|"BET_ALERT"|"PORTAL"|"QUOTE"|"FORM_SUBMISSION_INBOUNDDB"|"QUOTA"|"UNSUBSCRIBE"|"COMMUNICATION"|"FEEDBACK_SUBMISSION"|"ATTRIBUTION"|"SALESFORCE_SYNC_ERROR"|"RESTORABLE_CRM_OBJECT"|"HUB"|"LANDING_PAGE"|"PRODUCT_OR_FOLDER"|"TASK"|"FORM"|"MARKETING_EMAIL"|"AD_ACCOUNT"|"AD_CAMPAIGN"|"AD_GROUP"|"AD"|"KEYWORD"|"CAMPAIGN"|"SOCIAL_CHANNEL"|"SOCIAL_POST"|"SITE_PAGE"|"BLOG_POST"|"IMPORT"|"EXPORT"|"CTA"|"TASK_TEMPLATE"|"AUTOMATION_PLATFORM_FLOW"|"OBJECT_LIST"|"NOTE"|"MEETING_EVENT"|"CALL"|"EMAIL"|"PUBLISHING_TASK"|"CONVERSATION_SESSION"|"CONTACT_CREATE_ATTRIBUTION"|"INVOICE"|"MARKETING_EVENT"|"CONVERSATION_INBOX"|"CHATFLOW"|"MEDIA_BRIDGE"|"SEQUENCE"|"SEQUENCE_STEP"|"FORECAST"|"SNIPPET"|"TEMPLATE"|"DEAL_CREATE_ATTRIBUTION"|"QUOTE_TEMPLATE"|"QUOTE_MODULE"|"QUOTE_MODULE_FIELD"|"QUOTE_FIELD"|"SEQUENCE_ENROLLMENT"|"SUBSCRIPTION"|"ACCEPTANCE_TEST"|"SOCIAL_BROADCAST"|"DEAL_SPLIT"|"DEAL_REGISTRATION"|"GOAL_TARGET"|"GOAL_TARGET_GROUP"|"PORTAL_OBJECT_SYNC_MESSAGE"|"FILE_MANAGER_FILE"|"FILE_MANAGER_FOLDER"|"SEQUENCE_STEP_ENROLLMENT"|"APPROVAL"|"APPROVAL_STEP"|"CTA_VARIANT"|"SALES_DOCUMENT"|"DISCOUNT"|"FEE"|"TAX"|"MARKETING_CALENDAR"|"PERMISSIONS_TESTING"|"PRIVACY_SCANNER_COOKIE"|"DATA_SYNC_STATE"|"WEB_INTERACTIVE"|"PLAYBOOK"|"FOLDER"|"PLAYBOOK_QUESTION"|"PLAYBOOK_SUBMISSION"|"PLAYBOOK_SUBMISSION_ANSWER"|"COMMERCE_PAYMENT"|"GSC_PROPERTY"|"SOX_PROTECTED_DUMMY_TYPE"|"BLOG_LISTING_PAGE"|"QUARANTINED_SUBMISSION"|"PAYMENT_SCHEDULE"|"PAYMENT_SCHEDULE_INSTALLMENT"|"MARKETING_CAMPAIGN_UTM"|"DISCOUNT_TEMPLATE"|"DISCOUNT_CODE"|"FEEDBACK_SURVEY"|"CMS_URL"|"SALES_TASK"|"SALES_WORKLOAD"|"USER"|"POSTAL_MAIL"|"SCHEMAS_BACKEND_TEST"|"PAYMENT_LINK"|"SUBMISSION_TAG"|"CAMPAIGN_STEP"|"SCHEDULING_PAGE"|"SOX_PROTECTED_TEST_TYPE"|"ORDER"|"MARKETING_SMS"|"PARTNER_ACCOUNT"|"CAMPAIGN_TEMPLATE"|"CAMPAIGN_TEMPLATE_STEP"|"PLAYLIST"|"CLIP"|"CAMPAIGN_BUDGET_ITEM"|"CAMPAIGN_SPEND_ITEM"|"MIC"|"CONTENT_AUDIT"|"CONTENT_AUDIT_PAGE"|"PLAYLIST_FOLDER"|"LEAD"|"ABANDONED_CART"|"EXTERNAL_WEB_URL"|"VIEW"|"VIEW_BLOCK"|"ROSTER"|"CART"|"AUTOMATION_PLATFORM_FLOW_ACTION"|"SOCIAL_PROFILE"|"PARTNER_CLIENT"|"ROSTER_MEMBER"|"MARKETING_EVENT_ATTENDANCE"|"ALL_PAGES"|"AI_FORECAST"|"CRM_PIPELINES_DUMMY_TYPE"|"KNOWLEDGE_ARTICLE"|"PROPERTY_INFO"|"DATA_PRIVACY_CONSENT"|"GOAL_TEMPLATE"|"SCORE_CONFIGURATION"|"AUDIENCE"|"PARTNER_CLIENT_REVENUE"|"AUTOMATION_JOURNEY"|"UNKNOWN" referencedObjectType?;
    string name;
    Option[] options;
    string description?;
    string externalOptionsReferenceType?;
    string label?;
    "string"|"number"|"bool"|"datetime"|"enumeration"|"date"|"phone_number"|"currency_number"|"json"|"object_coordinates" 'type;
    "booleancheckbox"|"checkbox"|"date"|"file"|"number"|"phonenumber"|"radio"|"select"|"text"|"textarea"|"calculation_equation"|"calculation_rollup"|"calculation_score"|"calculation_read_time"|"unknown"|"html" fieldType?;
    string optionsUrl?;
    boolean externalOptions;
};

public type InputFieldDefinition record {
    boolean isRequired;
    string automationFieldType?;
    FieldTypeDefinition typeDefinition;
    ("STATIC_VALUE"|"OBJECT_PROPERTY"|"FIELD_DATA"|"FETCHED_OBJECT_PROPERTY"|"ENROLLMENT_EVENT_PROPERTY")[] supportedValueTypes?;
};

public type CollectionResponsePublicActionFunctionIdentifierNoPaging record {
    PublicActionFunctionIdentifier[] results;
};

# OAuth2 Refresh Token Grant Configs
public type OAuth2RefreshTokenGrantConfig record {|
    *http:OAuth2RefreshTokenGrantConfig;
    # Refresh URL
    string refreshUrl = "https://api.hubapi.com/oauth/v1/token";
|};

# Represents the Queries record for the operation: get-/{appId}_getPage
public type GetAppIdGetPageQueries record {
    # Whether to return only results that have been archived
    boolean archived = false;
    # The maximum number of results to display per page
    int:Signed32 'limit?;
    # The paging cursor token of the last successfully read resource will be returned as the `paging.next.after` JSON property of a paged response containing more results
    string after?;
};

public type PublicExecutionTranslationRule record {
    string labelName;
    record {|record {}...;|} conditions;
};

public type PublicActionFunctionIdentifier record {
    "PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType;
    string id?;
};

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Provides Auth configurations needed when communicating with a remote HTTP endpoint.
    http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig|ApiKeysConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    http:ClientHttp1Settings http1Settings = {};
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings = {};
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 30;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with Redirection
    http:FollowRedirects followRedirects?;
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache = {};
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with cookies
    http:CookieConfig cookieConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits = {};
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Provides settings related to client socket configuration
    http:ClientSocketConfig socketConfig = {};
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
    # Enables relaxed data binding on the client side. When enabled, `nil` values are treated as optional, 
    # and absent fields are handled as `nilable` types. Enabled by default.
    boolean laxDataBinding = true;
|};

public type PublicActionRevision record {
    string revisionId;
    string createdAt;
    PublicActionDefinition definition;
    string id;
};

public type CallbackCompletionRequest record {
    record {|string...;|} outputFields;
};

public type CollectionResponsePublicActionDefinitionForwardPaging record {
    ForwardPaging paging?;
    PublicActionDefinition[] results;
};

public type CollectionResponsePublicActionRevisionForwardPaging record {
    ForwardPaging paging?;
    PublicActionRevision[] results;
};

public type PublicActionDefinitionEggInputFieldDependencies PublicSingleFieldDependency|PublicConditionalSingleFieldDependency;

# Represents the Queries record for the operation: get-/{appId}/{definitionId}_getById
public type GetAppIdDefinitionIdGetByIdQueries record {
    # Whether to return only results that have been archived
    boolean archived = false;
};

public type CallbackCompletionBatchRequest record {
    record {|string...;|} outputFields;
    string callbackId;
};

public type PublicActionDefinitionEgg record {
    InputFieldDefinition[] inputFields;
    OutputFieldDefinition[] outputFields?;
    int archivedAt?;
    PublicActionFunction[] functions;
    string actionUrl;
    PublicActionDefinitionEggInputFieldDependencies[] inputFieldDependencies?;
    boolean published;
    PublicExecutionTranslationRule[] executionRules?;
    string[] objectTypes;
    PublicObjectRequestOptions objectRequestOptions?;
    record {|PublicActionLabels...;|} labels;
};

public type PublicActionDefinitionPatch record {
    InputFieldDefinition[] inputFields?;
    OutputFieldDefinition[] outputFields?;
    string actionUrl?;
    PublicActionDefinitionPatchInputFieldDependencies[] inputFieldDependencies?;
    boolean published?;
    PublicExecutionTranslationRule[] executionRules?;
    string[] objectTypes?;
    PublicObjectRequestOptions objectRequestOptions?;
    record {|PublicActionLabels...;|} labels?;
};

public type BatchInputCallbackCompletionBatchRequest record {
    CallbackCompletionBatchRequest[] inputs;
};

public type PublicActionDefinitionPatchInputFieldDependencies PublicSingleFieldDependency|PublicConditionalSingleFieldDependency;

public type Option record {
    boolean hidden;
    int:Signed32 displayOrder;
    decimal doubleData;
    string description;
    boolean readOnly;
    string label;
    string value;
};

public type OutputFieldDefinition record {
    FieldTypeDefinition typeDefinition;
};

public type NextPage record {
    string link?;
    string after;
};

# Provides API key configurations needed when communicating with a remote HTTP endpoint.
public type ApiKeysConfig record {|
    string hapikey;
    string privateAppLegacy;
|};

# Represents the Queries record for the operation: get-/{appId}/{definitionId}/revisions_getPage
public type GetAppIdDefinitionIdRevisionsGetPageQueries record {
    # The maximum number of results to display per page
    int:Signed32 'limit?;
    # The paging cursor token of the last successfully read resource will be returned as the `paging.next.after` JSON property of a paged response containing more results
    string after?;
};
