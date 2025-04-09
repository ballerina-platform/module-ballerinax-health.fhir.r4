type Term record {
    string code;
    string system;
    string version?;
};

type TerminologyConfig record {|
    boolean isTerminologyValidationEnabled = false;
    string terminologyServiceApi?;
    string tokenUrl?;
    string clientId?;
    string clientSecret?;
|};
