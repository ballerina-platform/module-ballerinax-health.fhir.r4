# Analytics with FHIR R4 service

FHIR R4 service comes with inbuilt analytics service, which can publish analytics logs to a configured server using a REST API call.

This is achieved through the `AnalyticsRequestInterceptor` which can intercept the received requests, collect the required attribute values and publishing to the configured `analyticsServerUrl`.

## Configuring Analytics

Inside the module which imports `ballerinax.health.fhirr4`, we need to have a `Config.toml` at the same level as `Ballerina.toml` including the necessary configs. Following is a clarification on those configs.

> - `analyticsEnabled` : To enable publishing logs to the configured analytics server
> - `analyticsRequiredAttributes` : Only the attributes listed here are taken from the jwt (`x-jwt-assertion` header value) to publish
> - `analyticsServerUrl` : Hosted analytics server url
> - `analyticsServerUsername` : BasicAuth username for the analytics server
> - `analyticsServerPassword` : BasicAuth password for the analytics server
> - `analyticsMoreInfoRequired` : Whether more information is required
> - `analyticsMoreInfoUrl` : An api to fetch more information required for analytics
> - `analyticsMoreInfoUsername` : BasicAuth username for more info api
> - `analyticsMoreInfoPassword` : BasicAuth password for more info api

### x-jwt-assertion Header :

The data which is published for analytics are taken from the `x-jwt-assertion` header coming in the http request. Only the attributes in the `analyticsRequiredAttributes` list are published.

### Analytics Server :

Analytics server can be any server which can capture analytics logs using API requests. AnalyticsRequestInterceptor only supports JSON format, where it sends logs as a JSON with string values to the configured server. Currently only Basic Auth is used (if configured) for api security.

For example `Opensearch` & `Opensearch Dashboards` can be used to capture logs, analyze and visualize.

### More Info API :

There can be information which are out of scope for the FHIR server, but may be required for analytics. The party which uses FHIR analytics can expose these info using an API (POST endpoint) which accepts a json with `requiredAttributes` as keys, and returns more info as a json with key:\<string>value pairs.

Check `more_info_api.yaml` for an open-api sample swagger.

> Note: The keys of the json response of the more info api should not change per request since analytics servers like Opensearch creates the index patterns at the very first log publishing request, and any new keys sent later will not be persisted under that index pattern.
