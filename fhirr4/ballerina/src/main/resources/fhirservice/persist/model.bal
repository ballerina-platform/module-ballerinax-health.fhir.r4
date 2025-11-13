import ballerina/persist as _;
import ballerinax/persist.sql;

type MoesifData record {|
    @sql:Generated
    readonly int id;
    byte[] data;
    boolean published;
|};


// convert to blob - done
// Register the job and publisher in fhir registry - done
// If utils are used to convert from json to byte and vice versa, keep them as utils for everyone to use - done
// Refine the interface publish function to take all the data in. - done
