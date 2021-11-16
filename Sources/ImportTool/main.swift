import ImportToolCore

let importer = Importer()

let inputAllHubspot = "/Users/tim/Casper/hubspot-2021-11-15.csv"
let inputCasper = "/Users/tim/Casper/2Packs18k.csv"
let outputDuplicatesCasper = "/Users/tim/Casper/CasperDuplicates.csv"
let outputPotentialDuplicates = "/Users/tim/Casper/PotentialDuplicates.csv"
let outputNewLeads = "/Users/tim/Casper/NewLeads.csv"

func allExisting() throws -> [HubspotContact] {
    let activeHubspotContacts = try importer
        .hubspotContacts(from: inputAllHubspot)
    
    let hubspotUnique = Array(Set(activeHubspotContacts))

    let lists500 = Array(Set(try importer.lists500()))

    return hubspotUnique + lists500
}

let casperContacts = try importer
    .casperContacts(from: inputCasper)

print("Imported \(casperContacts.count).")

let casperConverted = casperContacts.map { CasperMapper(contact: $0).toHubspot }

let result = findPotentialDuplicatesInItself(contacts: casperConverted)

importer.writeHubpostContacts(Array(result.potentialDuplicates), to: "/Users/tim/Casper/CasperDuplicates.csv")

print("Found \(casperConverted.count - result.duplicatesChecked.count) duplicates in imported data.")
print("After duplicates removal remaining:\n\(result.duplicatesChecked.count)")

let sortedByReviews = result
    .duplicatesChecked
    .sorted(by: { (Int($0.numberOfReviews) ?? 0) < (Int($1.numberOfReviews) ?? 0) })

let casper = sortedByReviews.filter {
    !($0.numberOfReviews == "")
        && ($0.phone.filter("0123456789".contains).count > 5)
}

print("After removing potentially invalid phone numbers and without number of reviews:\n\(casper.count)")

let all = try allExisting()

let potentialDuplicatesResult = findPotentialDuplicates(in: casper, data: all)
print("Found \(potentialDuplicatesResult.potentialDuplicates.count) potential duplicates after comparing with other sources.")
print("After removing potential duplicates from other sources:\n\(potentialDuplicatesResult.duplicatesChecked.count)")

importer.writeHubpostContacts(Array(potentialDuplicatesResult.potentialDuplicates), to: outputPotentialDuplicates)
importer.writeHubpostContacts(Array(potentialDuplicatesResult.duplicatesChecked), to: outputNewLeads)
