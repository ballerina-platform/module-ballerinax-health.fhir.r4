public configurable CdsService[] cds_services = ?;

// Validating the CDS hooks before registering
function init() returns error? {
    string[] cdsServiceIds = [];
    foreach CdsService cdsService in cds_services {

        // Check whether there are any CDS defintions with same id before registering
        if (cdsServiceIds.filter(s => s == cdsService.id).length() > 0) {
            string message = string `You are trying to register cds service it has been already registered with a same id: ${cdsService.id}`;
            return createCdsError(message, 400);
        }
        cdsServiceIds.push(cdsService.id);
    }
}
