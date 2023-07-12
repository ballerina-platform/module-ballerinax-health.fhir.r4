// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com).

// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Hold FHIR related information in a particular deployment
public isolated class FHIRRegistry {

    private FHIRImplementationGuide[] implementationGuides = [];

    // profile map (key: profile url)
    private map<readonly & Profile> profileMap = {};

    // maintain resource type to profiles mapping
    private map<map<Profile>> resourceTypeProfiles = {};

    // resource type to profile of FHIR Base resources
    private map<readonly & Profile> fhirBaseIGProfiles = {};

    // search parameter map (key: resource type)
    private map<SearchParamCollection> searchParameterMap = {};

    public function init() {
    }

    # Add an implementation guide to the registry
    #
    # + ig - The implementation guide to be added
    # + return - An error if the implementation guide is invalid or an error occurred while adding the implementation guide
    public function addImplementationGuide(FHIRImplementationGuide ig) returns FHIRError? {
        lock {
            self.implementationGuides.push(ig);
        }

        lock {
            // add profiles to profile map
            foreach Profile profile in ig.getProfiles() {
                readonly & Profile profileClone = profile.cloneReadOnly();
                self.profileMap[profileClone.url] = profileClone;

                // Add to resource type bound profile mapping
                //ResourceDefinitionRecord resourceDefinition = check getResourceDefinition(profileClone.modelType);
                map<Profile> profiles;
                if self.resourceTypeProfiles.hasKey(profileClone.resourceType) {
                    profiles = self.resourceTypeProfiles.get(profileClone.resourceType);
                } else {
                    profiles = {};
                    self.resourceTypeProfiles[profileClone.resourceType] = profiles;
                }
                profiles[profileClone.url] = profileClone;

                // If the processed IG is FHIR base IG, we need to add it to FHIR base profile map
                if ig.getName() == FHIR_BASE_IG {
                    //ResourceDefinitionRecord resourceDef = check getResourceDefinition(profile.modelType);
                    self.fhirBaseIGProfiles[profileClone.resourceType] = profileClone;
                }
            }
        }

        lock {
            // Add search parameters
            foreach map<FHIRSearchParameterDefinition[]> paramsMap in ig.getSearchParameters() {
                foreach FHIRSearchParameterDefinition[] params in paramsMap {
                    foreach FHIRSearchParameterDefinition param in params {
                        foreach string resourceType in param.base {
                            if (self.searchParameterMap.hasKey(resourceType)) {
                                SearchParamCollection collection = self.searchParameterMap.get(resourceType);
                                if !collection.hasKey(param.name) {
                                    collection[param.name] = param;
                                }
                            } else {
                                SearchParamCollection collection = {};
                                collection[param.name] = param;
                                self.searchParameterMap[resourceType] = collection;
                            }
                        }
                    }
                }
            }
        }
    }

    # Get the resource profiles in the registry
    #
    # + resourceType - The resource type
    # + return - The profiles in the registry
    public isolated function getResourceProfiles(string resourceType) returns readonly & map<Profile & readonly> {
        lock {
            if !self.resourceTypeProfiles.hasKey(resourceType) {
                return {};
            }
            return self.resourceTypeProfiles.get(resourceType).cloneReadOnly();
        }
    }

    # Get the resource search parameters in the registry
    #
    # + resourceType - The resource type
    # + return - The search parameters in the registry
    public isolated function getResourceSearchParameters(string resourceType) returns SearchParamCollection {
        lock {
            if self.searchParameterMap.hasKey(resourceType) {
                return self.searchParameterMap.get(resourceType).cloneReadOnly();
            }
        }
        return {};
    }

    # Get the search parameters in the registry by name
    #
    # + resourceType - The resource type
    # + name - The name of the search parameter
    # + return - The search parameters in the registry
    public isolated function getResourceSearchParameterByName(string resourceType, string name) returns FHIRSearchParameterDefinition? {
        lock {
            if self.searchParameterMap.hasKey(resourceType) && self.searchParameterMap.get(resourceType).hasKey(name) {
                return self.searchParameterMap.get(resourceType).get(name).clone();
            }
        }
        return ();
    }

    # Get the profiles in the registry
    #
    # + url - The url of the profile
    # + return - The profiles in the registry
    public isolated function findProfile(string url) returns (readonly & Profile)? {
        lock {
            if self.profileMap.hasKey(url) {
                return self.profileMap.get(url);
            }
        }
        return ();
    }

    # Get the base profiles in the registry
    #
    # + resourceType - The resource type
    # + return - The base profile in the registry
    public isolated function findBaseProfile(string resourceType) returns (readonly & Profile)? {
        lock {
            if self.fhirBaseIGProfiles.hasKey(resourceType) {
                return self.fhirBaseIGProfiles.get(resourceType);
            }
        }
        return ();
    }

    # Check the resource type is supported by the registry
    #
    # + resourceType - The resource type
    # + return - True if the resource type is supported
    public isolated function isSupportedResource(string resourceType) returns boolean {
        lock {
            return self.resourceTypeProfiles.hasKey(resourceType);
        }
    }
}

# Search parameter map (key: parameter name)
public type SearchParamCollection map<FHIRSearchParameterDefinition>;
