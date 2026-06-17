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

# Defines a serverless function associated with an automation action, including its source code and execution lifecycle type.
public type PublicActionFunction record {
    # The source code of the function.
    string functionSource;
    # The lifecycle stage at which the function executes.
    "PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType;
    # The unique identifier of the function.
    string id?;
};

# Defines a custom automation action, including its endpoint, input/output fields, labels, associated functions, and publication state.
public type PublicActionDefinition record {
    # List of function identifiers associated with this action.
    PublicActionFunctionIdentifier[] functions;
    # The URL endpoint invoked when the action executes.
    string actionUrl;
    # Indicates whether the action is published and available for use.
    boolean published;
    # Localized display labels for the action, keyed by language code.
    record {|PublicActionLabels...;|} labels;
    # List of input fields the action accepts during execution.
    InputFieldDefinition[] inputFields;
    # List of output fields the action returns after execution.
    OutputFieldDefinition[] outputFields?;
    # The identifier of the current revision of the action definition.
    string revisionId;
    # Timestamp (ms) when the action was archived, if applicable.
    int archivedAt?;
    # Conditional dependencies that control input field visibility or behavior.
    PublicActionDefinitionInputFieldDependencies[] inputFieldDependencies?;
    # Rules that govern how the action execution is translated or applied.
    PublicExecutionTranslationRule[] executionRules?;
    # The unique identifier of the action definition.
    string id;
    # CRM object types this action can be applied to.
    string[] objectTypes;
    # Options for a public object request, specifying which properties to retrieve.
    PublicObjectRequestOptions objectRequestOptions?;
};

# Defines a conditional dependency where dependent fields are shown or hidden based on a single controlling field's value.
public type PublicConditionalSingleFieldDependency record {
    # The type of field dependency; always CONDITIONAL_SINGLE_FIELD.
    "CONDITIONAL_SINGLE_FIELD" dependencyType = "CONDITIONAL_SINGLE_FIELD";
    # Name of the field that controls the dependency.
    string controllingFieldName;
    # The value of the controlling field that triggers the dependency.
    string controllingFieldValue;
    # List of field names dependent on the controlling field's value.
    string[] dependentFieldNames;
};

# Defines a field dependency as either a single-field or conditional single-field dependency type.
public type PublicActionDefinitionInputFieldDependencies PublicSingleFieldDependency|PublicConditionalSingleFieldDependency;

# Options for a public object request, specifying which properties to retrieve.
public type PublicObjectRequestOptions record {
    # List of property names to include in the object response.
    string[] properties;
};

# Localized display labels for an action, including field labels, descriptions, and card content.
public type PublicActionLabels record {
    # Map of input field names to their descriptive text.
    record {|string...;|} inputFieldDescriptions?;
    # Display name of the app associated with the action.
    string appDisplayName?;
    # Map of output field names to their display labels.
    record {|string...;|} outputFieldLabels?;
    # Nested map of input field option keys to their display labels.
    record {|record {|string...;|}...;|} inputFieldOptionLabels?;
    # Human-readable description of the action's purpose.
    string actionDescription?;
    # Map of execution rule keys to their display label strings.
    record {|string...;|} executionRules?;
    # Map of input field names to their display labels.
    record {|string...;|} inputFieldLabels?;
    # Display name of the action.
    string actionName;
    # Text content displayed on the action's summary card.
    string actionCardContent?;
};

# Defines a SINGLE_FIELD dependency linking a controlling field to one or more dependent fields.
public type PublicSingleFieldDependency record {
    # The type of field dependency; always 'SINGLE_FIELD'.
    "SINGLE_FIELD" dependencyType = "SINGLE_FIELD";
    # The name of the field that controls the dependency.
    string controllingFieldName;
    # List of field names dependent on the controlling field.
    string[] dependentFieldNames;
};

# Pagination wrapper containing a reference to the next page of results.
public type ForwardPaging record {
    # Pagination cursor object used to retrieve the next page of results.
    NextPage next?;
};

# Defines the type, display, and option configuration for an action input field.
public type FieldTypeDefinition record {
    # Supplementary help text displayed alongside the field.
    string helpText?;
    # The HubSpot object type this field references.
    "CONTACT"|"COMPANY"|"DEAL"|"ENGAGEMENT"|"TICKET"|"OWNER"|"PRODUCT"|"LINE_ITEM"|"BET_DELIVERABLE_SERVICE"|"CONTENT"|"CONVERSATION"|"BET_ALERT"|"PORTAL"|"QUOTE"|"FORM_SUBMISSION_INBOUNDDB"|"QUOTA"|"UNSUBSCRIBE"|"COMMUNICATION"|"FEEDBACK_SUBMISSION"|"ATTRIBUTION"|"SALESFORCE_SYNC_ERROR"|"RESTORABLE_CRM_OBJECT"|"HUB"|"LANDING_PAGE"|"PRODUCT_OR_FOLDER"|"TASK"|"FORM"|"MARKETING_EMAIL"|"AD_ACCOUNT"|"AD_CAMPAIGN"|"AD_GROUP"|"AD"|"KEYWORD"|"CAMPAIGN"|"SOCIAL_CHANNEL"|"SOCIAL_POST"|"SITE_PAGE"|"BLOG_POST"|"IMPORT"|"EXPORT"|"CTA"|"TASK_TEMPLATE"|"AUTOMATION_PLATFORM_FLOW"|"OBJECT_LIST"|"NOTE"|"MEETING_EVENT"|"CALL"|"EMAIL"|"PUBLISHING_TASK"|"CONVERSATION_SESSION"|"CONTACT_CREATE_ATTRIBUTION"|"INVOICE"|"MARKETING_EVENT"|"CONVERSATION_INBOX"|"CHATFLOW"|"MEDIA_BRIDGE"|"SEQUENCE"|"SEQUENCE_STEP"|"FORECAST"|"SNIPPET"|"TEMPLATE"|"DEAL_CREATE_ATTRIBUTION"|"QUOTE_TEMPLATE"|"QUOTE_MODULE"|"QUOTE_MODULE_FIELD"|"QUOTE_FIELD"|"SEQUENCE_ENROLLMENT"|"SUBSCRIPTION"|"ACCEPTANCE_TEST"|"SOCIAL_BROADCAST"|"DEAL_SPLIT"|"DEAL_REGISTRATION"|"GOAL_TARGET"|"GOAL_TARGET_GROUP"|"PORTAL_OBJECT_SYNC_MESSAGE"|"FILE_MANAGER_FILE"|"FILE_MANAGER_FOLDER"|"SEQUENCE_STEP_ENROLLMENT"|"APPROVAL"|"APPROVAL_STEP"|"CTA_VARIANT"|"SALES_DOCUMENT"|"DISCOUNT"|"FEE"|"TAX"|"MARKETING_CALENDAR"|"PERMISSIONS_TESTING"|"PRIVACY_SCANNER_COOKIE"|"DATA_SYNC_STATE"|"WEB_INTERACTIVE"|"PLAYBOOK"|"FOLDER"|"PLAYBOOK_QUESTION"|"PLAYBOOK_SUBMISSION"|"PLAYBOOK_SUBMISSION_ANSWER"|"COMMERCE_PAYMENT"|"GSC_PROPERTY"|"SOX_PROTECTED_DUMMY_TYPE"|"BLOG_LISTING_PAGE"|"QUARANTINED_SUBMISSION"|"PAYMENT_SCHEDULE"|"PAYMENT_SCHEDULE_INSTALLMENT"|"MARKETING_CAMPAIGN_UTM"|"DISCOUNT_TEMPLATE"|"DISCOUNT_CODE"|"FEEDBACK_SURVEY"|"CMS_URL"|"SALES_TASK"|"SALES_WORKLOAD"|"USER"|"POSTAL_MAIL"|"SCHEMAS_BACKEND_TEST"|"PAYMENT_LINK"|"SUBMISSION_TAG"|"CAMPAIGN_STEP"|"SCHEDULING_PAGE"|"SOX_PROTECTED_TEST_TYPE"|"ORDER"|"MARKETING_SMS"|"PARTNER_ACCOUNT"|"CAMPAIGN_TEMPLATE"|"CAMPAIGN_TEMPLATE_STEP"|"PLAYLIST"|"CLIP"|"CAMPAIGN_BUDGET_ITEM"|"CAMPAIGN_SPEND_ITEM"|"MIC"|"CONTENT_AUDIT"|"CONTENT_AUDIT_PAGE"|"PLAYLIST_FOLDER"|"LEAD"|"ABANDONED_CART"|"EXTERNAL_WEB_URL"|"VIEW"|"VIEW_BLOCK"|"ROSTER"|"CART"|"AUTOMATION_PLATFORM_FLOW_ACTION"|"SOCIAL_PROFILE"|"PARTNER_CLIENT"|"ROSTER_MEMBER"|"MARKETING_EVENT_ATTENDANCE"|"ALL_PAGES"|"AI_FORECAST"|"CRM_PIPELINES_DUMMY_TYPE"|"KNOWLEDGE_ARTICLE"|"PROPERTY_INFO"|"DATA_PRIVACY_CONSENT"|"GOAL_TEMPLATE"|"SCORE_CONFIGURATION"|"AUDIENCE"|"PARTNER_CLIENT_REVENUE"|"AUTOMATION_JOURNEY"|"UNKNOWN" referencedObjectType?;
    # The internal name identifier of the field type.
    string name;
    # List of selectable options available for the field.
    Option[] options;
    # A human-readable description of the field type.
    string description?;
    # Reference type used to resolve externally sourced options.
    string externalOptionsReferenceType?;
    # The display label shown to users for the field.
    string label?;
    # The data type of the field value (e.g., string, number, bool).
    "string"|"number"|"bool"|"datetime"|"enumeration"|"date"|"phone_number"|"currency_number"|"json"|"object_coordinates" 'type;
    # The UI control type used to render the field.
    "booleancheckbox"|"checkbox"|"date"|"file"|"number"|"phonenumber"|"radio"|"select"|"text"|"textarea"|"calculation_equation"|"calculation_rollup"|"calculation_score"|"calculation_read_time"|"unknown"|"html" fieldType?;
    # URL endpoint for fetching field options dynamically.
    string optionsUrl?;
    # Indicates whether options are loaded from an external source.
    boolean externalOptions;
};

# Defines an input field for an action, including its type and accepted value sources.
public type InputFieldDefinition record {
    # Indicates whether the input field is required.
    boolean isRequired;
    # The automation-specific field type identifier.
    string automationFieldType?;
    # Defines the type, display, and option configuration for an action input field.
    FieldTypeDefinition typeDefinition;
    # List of value types accepted by this input field.
    ("STATIC_VALUE"|"OBJECT_PROPERTY"|"FIELD_DATA"|"FETCHED_OBJECT_PROPERTY"|"ENROLLMENT_EVENT_PROPERTY")[] supportedValueTypes?;
};

# A collection of action function identifiers returned without paging.
public type CollectionResponsePublicActionFunctionIdentifierNoPaging record {
    # List of action function identifiers in the response.
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

# Defines a translation rule mapping execution conditions to a display label.
public type PublicExecutionTranslationRule record {
    # The display label name for this translation rule.
    string labelName;
    # Key-value map of conditions that trigger this translation rule.
    record {|record {}...;|} conditions;
};

# Identifies a function associated with a public action by type and optional ID.
public type PublicActionFunctionIdentifier record {
    # The execution stage at which this function is invoked.
    "PRE_ACTION_EXECUTION"|"PRE_FETCH_OPTIONS"|"POST_FETCH_OPTIONS"|"POST_ACTION_EXECUTION" functionType;
    # The unique identifier of the action function.
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

# Represents a versioned revision of a public action definition.
public type PublicActionRevision record {
    # The unique identifier for this action revision.
    string revisionId;
    # The timestamp when this revision was created.
    string createdAt;
    # Defines a custom automation action, including its endpoint, input/output fields, labels, associated functions, and publication state.
    PublicActionDefinition definition;
    # The unique identifier of the action revision record.
    string id;
};

# Request payload for completing an action callback with output field values.
public type CallbackCompletionRequest record {
    record {|string...;|} outputFields;
};

# A paginated collection of public action definitions with forward paging support.
public type CollectionResponsePublicActionDefinitionForwardPaging record {
    # Pagination wrapper containing a reference to the next page of results.
    ForwardPaging paging?;
    # The list of returned public action definitions.
    PublicActionDefinition[] results;
};

# Paginated collection of public action revision records
public type CollectionResponsePublicActionRevisionForwardPaging record {
    # Pagination wrapper containing a reference to the next page of results.
    ForwardPaging paging?;
    # Array of public action revision objects returned in this page
    PublicActionRevision[] results;
};

# Input field dependency definition; either a single or conditional single field dependency
public type PublicActionDefinitionEggInputFieldDependencies PublicSingleFieldDependency|PublicConditionalSingleFieldDependency;

# Represents the Queries record for the operation: get-/{appId}/{definitionId}_getById
public type GetAppIdDefinitionIdGetByIdQueries record {
    # Whether to return only results that have been archived
    boolean archived = false;
};

# Request payload for completing a batch callback with output field values
public type CallbackCompletionBatchRequest record {
    # Key-value map of output field names to their resolved string values
    record {|string...;|} outputFields;
    # Unique identifier of the callback to complete
    string callbackId;
};

# Request payload for creating a new custom automation action definition
public type PublicActionDefinitionEgg record {
    # Array of input field definitions accepted by this action
    InputFieldDefinition[] inputFields;
    # Array of output field definitions produced by this action
    OutputFieldDefinition[] outputFields?;
    # Timestamp (ms) indicating when the action definition was archived
    int archivedAt?;
    # Array of serverless functions associated with this action
    PublicActionFunction[] functions;
    # Endpoint URL invoked when this action executes
    string actionUrl;
    # Array of dependency rules governing input field visibility or behavior
    PublicActionDefinitionEggInputFieldDependencies[] inputFieldDependencies?;
    # Indicates whether this action definition is publicly published
    boolean published;
    # Array of rules controlling when and how this action executes
    PublicExecutionTranslationRule[] executionRules?;
    # CRM object types this action is applicable to
    string[] objectTypes;
    # Options for a public object request, specifying which properties to retrieve.
    PublicObjectRequestOptions objectRequestOptions?;
    # Localized display labels for the action, keyed by language code.
    record {|PublicActionLabels...;|} labels;
};

# Partial update payload for modifying an existing custom action definition.
public type PublicActionDefinitionPatch record {
    # Updated list of input field definitions for the action.
    InputFieldDefinition[] inputFields?;
    # Updated list of output field definitions returned by the action.
    OutputFieldDefinition[] outputFields?;
    # The URL endpoint invoked when the action executes.
    string actionUrl?;
    # Conditional dependencies controlling input field visibility or behavior.
    PublicActionDefinitionPatchInputFieldDependencies[] inputFieldDependencies?;
    # Whether the action is published and available for use in workflows.
    boolean published?;
    # Rules that govern how and when the action execution is translated.
    PublicExecutionTranslationRule[] executionRules?;
    # CRM object types this action is applicable to.
    string[] objectTypes?;
    # Options for a public object request, specifying which properties to retrieve.
    PublicObjectRequestOptions objectRequestOptions?;
    # Localized display labels for the action, keyed by language code.
    record {|PublicActionLabels...;|} labels?;
};

# A batch of callback completion requests to resolve multiple pending action callbacks.
public type BatchInputCallbackCompletionBatchRequest record {
    # Array of individual callback completion requests in the batch.
    CallbackCompletionBatchRequest[] inputs;
};

# A field dependency rule; either a single-field or conditional single-field dependency.
public type PublicActionDefinitionPatchInputFieldDependencies PublicSingleFieldDependency|PublicConditionalSingleFieldDependency;

# A selectable option for an input field, including its label, value, and display metadata.
public type Option record {
    # Whether this option is hidden from the user interface.
    boolean hidden;
    # Numeric order in which the option appears in the UI.
    int:Signed32 displayOrder;
    # Numeric double value associated with the option.
    decimal doubleData;
    # Human-readable description of the option.
    string description;
    # Indicates whether the option is read-only.
    boolean readOnly;
    # Display label shown to users for the option.
    string label;
    # Stored string value representing the option.
    string value;
};

# Defines an output field, including its type definition for an automation action.
public type OutputFieldDefinition record {
    # Defines the type, display, and option configuration for an action input field.
    FieldTypeDefinition typeDefinition;
};

# Pagination cursor object used to retrieve the next page of results.
public type NextPage record {
    # URL link to the next page of results.
    string link?;
    # Cursor token used to fetch the next page of results.
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
