import ballerina/persist as _;
import ballerinax/persist.sql;

type MoesifData record {|
    @sql:Generated
    readonly int id;
    byte[] data;
    boolean published;
|};
