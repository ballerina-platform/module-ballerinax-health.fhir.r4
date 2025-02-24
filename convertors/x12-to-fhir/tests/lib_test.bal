import ballerina/io;
import ballerina/regex;
import ballerina/test;

// Test function

@test:Config {}
function testFunction() {
    string expected = "ST*278*del*005010X217~BHT*0007*13*del*del*del~HL*1**20*1~NM1*provv*2*AcmeLabs*****PI*1144221847~HL*2*1*21*1~NM1*codeeee*2*LalalaLabs*****XX*1144221847~N3*3300WashtenawAvenue,Suite227*rollloooooooo~N4*Amherst*MA*01002*USA~PER*IC*Johnconstantine*EM*077782345ext.878*TE*071222333ext.928*EX*928~HL*3*2*22*1~NM1*IL*1*Shaw*Amy*V.*Ms*Dr*MI*1032702~REF*SY*10000~N3*49MEADOWST*APT2~N4*MOUNDS*OK*74047*LK~DMG*D8*1987-02-20*F~INS*Y*18******UNK~HL*del*del*23*1~NM1*QC*1*Shaw*Amy*V.**Dr~REF*del*1032702~N3*49MEADOWST*APT2~N4*MOUNDS*OK*74047*LK~DMG*D8*1987-02-20*F~INS*N*G8~HL*del*del*EV*1~TRN*1*111099*9012345678*TRN04-Value~UM*um01-codee*um02-codee*um03-codee*home:B*UM05-01_codee:::UM05-04_statee:UM05-05_countryy*UM6-codee~DTP*439*2019-07-20T11:01:00+05:00*D8~DTP*AAH*D8*2024-07-09~DTP*435*RD8*2020-07-02~DTP*096*D8*2030-07-10~HI*ABJ:I10*ABK:200*APR:300*ABF:400*BJ:500*BK:600*PR:700*BF:800*DRG:I10*DRG:I10*DRG:I10*DRG:I10~CL1*101*102*103*104~MSG*MSG01~NM1*practioner101*1*practitioner103*practitioner104*practitioner105*practitioner106*practitioner107*34*88800933501~REF*1J*valueREF02~N3*lineN301*lineN302~N4*cityN401*stateN402*postalN403*countryN404***districtN407~PER*IC***077782345ext.878*EX*878*UR*0332225280ext.1028~PRV*practioner101*PXC*practioner_PRV03~";

    //Converting claim resource to json representation of x12
    X12_005010X217_278A1|error x12Json = transform(bundle);
    if (x12Json is error) {
        io:println("Error when transforming fhir claim to x12 json");
        io:println(x12Json.message());
        return;
    }

    // Converting x12 json representation of x12 to x12 edi
    string|error ediString_X12 = toEdiString(x12Json);
    if (ediString_X12 is string) {
        //Converting x12 edi string back to x12 json for testing
        string cleanedX12 = regex:replaceAll(ediString_X12, "\\s", "");
        test:assertEquals(cleanedX12, expected);
    } else {
        io:println("Error when converting x12 json to x12 edi string");
        io:println(ediString_X12.message());
    }
}
