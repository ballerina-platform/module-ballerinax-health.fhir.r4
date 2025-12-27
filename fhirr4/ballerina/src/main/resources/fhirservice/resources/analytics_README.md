# Analytics with FHIR R4 service

FHIR R4 service comes with inbuilt analytics service, which can publish analytics logs to a configured server using a REST API call.

This is achieved through the `AnalyticsResponseInterceptor` which can intercept the outgoing responses, collect the required attribute values and publishing to the configured Analytics Server.

## Configuring Analytics for OpenSearch

Inside the module which imports `ballerinax.health.fhirr4`, we need to have a `Config.toml` at the same level as `Ballerina.toml` including the necessary configs. Following is a clarification on those configs.

```
[ballerinax.health.fhirr4.analytics]
```
> - `enabled` : To enable publishing logs to the configured analytics server
> - `attributes` : Only the attributes listed here are taken from the jwt (`x-jwt-assertion` header value) to publish
> - `publisher` : Configure the required analytics publisher. Applicable values are "moesif" and "opensearch"

If "opensearch" is configured as the analytics publisher, the following configurations must be configured.

```
[ballerinax.health.fhirr4.openSearch]
```
> - `url` : Analytics server url
> - `username` : BasicAuth username for the analytics server
> - `password` : BasicAuth password for the analytics server

### More Info API :

There can be information which are out of scope for the FHIR server, but may be required for analytics. The party which uses FHIR analytics can expose these info using an API (POST endpoint) which accepts a json with `ballerinax.health.fhirr4.analytics.attributes` as keys, and returns more info as a json with key:\<string>value pairs.

Check `more_info_api.yaml` for an open-api sample swagger.

> Note: The keys of the json response of the more info api should not change per request since analytics servers like Opensearch creates the index patterns at the very first log publishing request, and any new keys sent later will not be persisted under that index pattern.

```
[ballerinax.health.fhirr4.openSearch.moreInfo]
```
> - `enabled` : Whether more information is required or not
> - `url` : An api to fetch more information required for analytics
> - `username` : BasicAuth username for more info api
> - `password` : BasicAuth password for more info api

## Configuring Analytics for Moesif

If "moesif" is configured as the analytics publisher, the following configurations must be configured. A moesif account should be created and a moesif application id is required for this.

```
[ballerinax.health.fhirr4.moesifPublisherJob]
```
> - `enabled` : Whether the moesif data publisher job is enabled or not
> - `appId` : The moesif application identifier
> - `url` : Moesif API URL for publishing data (should be "https://api.moesif.net/v1/actions") 
> - `frequency` Frequency to run the data publishing job. (eg: 30.0)
> - `batchSize` Batch size or the records retrieved from the DB when publishing
> - `maxRetries` Retry count for the publisher job
> - `retryInterval` Interval for the retry attempts (eg: 5.0)
```
A database should be created beforehand and the database details should be configured under `[ballerinax.health.fhirr4.store]` configuration.

[ballerinax.health.fhirr4.store]
```
> - `host` Database host
> - `port` Database port
> - `user` Database user
> - `password` Database password
> - `database` Database name

### x-jwt-assertion Header :

The data which is published for analytics are taken mostly from the `x-jwt-assertion` header coming in the http request. Only the attributes in the `ballerinax.health.fhirr4.analytics.attributes` list are published.

### Analytics Server :

Analytics server can be any server which can capture analytics logs using API requests. AnalyticsResponseInterceptor only supports JSON format, where it sends logs as a JSON with string values to the configured server. Currently only Basic Auth is used (if configured) for api security.

For example `Opensearch` & `Opensearch Dashboards` or `Moesif` can be used to capture logs, analyze and visualize.
