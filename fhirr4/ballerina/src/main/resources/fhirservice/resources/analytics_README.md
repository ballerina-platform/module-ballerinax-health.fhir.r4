# CMS FHIR API Analytics

CMS requires Patient Access API Metrics to be published to CMS annually. This requirement can be achieved using the `AnalyticsResponseInterceptor`, which comes inbuilt in the `health.fhirr4` service.

# Overview

The ```AnalyticsResponseInterceptor``` intercepts the FHIR APIs and writes the required data in a preconfigured log file. Based on the following configuration, the log file path and the name will be decided. Also, there is the capability to allow or exclude APIs as required using the configurations. The optional support of payload publishing is also provided through a configuration. 

In addition to that, the a separate configuration is introduced to host a separate service in case additional data needs to be included. Find more information on this in the ```Enrich Analytics Payload Endpoint``` section.

## Configurations
The following configuration model is used in this analytics solution. The default configuration is provided below. By default it is disabled.

 ```toml
[ballerinax.health.fhirr4.analytics]
enabled = false
fhirServerContext = "/fhir/r4/"
jwtAttributes = ["client_id", "iss"]
shouldPublishPayloads = false
filePath = "logs"
fileName = "fhir-analytics"
allowedApiContexts = []
excludedApiContexts = []
```

* **Configuration Descriptions**:
> - enabled: 
	 - enable or disable analytics. Disable by default.
> - fhirServerContext:
	- this is the context path of the FHIR server (mandatory). **Must match the server path and must end with the trailing slash**.
> - jwtAttributes: 
	- a comma-separated list of strings of the attributes that are contained in the x-jwt-assertion header that should be considered for data writing. If no values are required, the list should remain empty. The values should exactly match the claims present in the x-jwt-assertion header. Only the specified values are considered for analytics. In the above example, the ```client_id``` and ```iss``` is expected to be present in the ```x-jwt-assertion``` header.
> - shouldPublishPayloads: 
	- determines whether the request payloads (request/response) should be written to the log file. Disabled by default.
> - filePath:
	- path where the log file should be created. This is relative to the server location. A nested path can also be configured if required (eg: foo/bar). If the directories are not created during the server startup, they will be automatically created. If ```filePath``` is not configured, a default directory named ```logs``` will be created.
> - fileName:
	- name of the log file that is created. If the file doesn’t exist in the configured path, the file will be automatically created during the server startup. If ```fileName``` is not configured, a default log file named ```fhir-analytics``` will be created inside the default ```filePath```.
> - allowedApiContexts:
	- a list of comma-separated regexes. If it requires allowing only a set of defined APIs through the interceptor, they should be configured in this list as comma-separated strings. These can be valid regexes.
> - excludedApiContexts: 
	- a list of comma-separated regexes. If it requires to not to allow only a set of defined APIs through the interceptor, they should be configured in this list as comma-separated strings. These can be valid regexes. If both lists are configured, the priority will be given to the excluded list, and the allowed list will be ignored.

## Enrich Analytics Payload Endpoint

This endpoint is provided for the user to optionally add any additional data to the analytics payload from a separate backend. The configuration below is used to define the URL of this backend server and the security credentials for basic authentication. Note that this payload enrichment only applies when the ```shouldPublishPayloads``` configuration is set to true.

```toml
[ballerinax.health.fhirr4.analytics.enrichPayload]
enabled = true
url = "http://<HOST>:<PORT>/enrich-analytics-payload"
username = ""
password = ""
```

* **Configuration Descriptions**:
> - enabled:
	- payload data enrichment will only work if this is set to true and the ```shouldPublishPayloads``` configuration is enabled.
> - url: 
	- the URL of the external server
> - username:
	- username for the basic authentication of the server
> - password:
	- password for the basic authentication of the server
    
Check ```enrich_analytics_payload_api.yaml``` in ```module-ballerinax-health.fhir.r4/fhirr4/ballerina/src/main/resources/fhirservice/resources``` for a sample open-api swagger.

## How to implement analytics publishing

A custom Fluent Bit configuration can be used to monitor the log file which the analytics data are written using the `AnalyticsResponseInterceptor`. You can find sample Fluent Bit configurations for Moesif and Microsoft Fabric analytics platforms by referring to [analytics_README.md](https://github.com/wso2/reference-implementation-cms0057f/blob/main/fhir-service/resources/analytics_README.md).