// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

public type MoesifData record {|
    readonly int id;
    byte[] data;
    boolean published;
|};

public type MoesifDataOptionalized record {|
    int id?;
    byte[] data?;
    boolean published?;
|};

public type MoesifDataTargetType typedesc<MoesifDataOptionalized>;

public type MoesifDataInsert record {|
    byte[] data;
    boolean published;
|};

public type MoesifDataUpdate record {|
    byte[] data?;
    boolean published?;
|};

