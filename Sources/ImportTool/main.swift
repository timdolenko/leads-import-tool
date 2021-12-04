import ImportToolCore

let importer = Importer()

let inputAllHubspot = "/Users/tim/Casper/Source/hubspot-2021-11-15.csv"
let inputCasper = "/Users/tim/Casper/Pack3+Revenue.csv"
let outputDuplicatesCasper = "/Users/tim/Casper/Results/CasperDuplicates.csv"
let outputPotentialDuplicates = "/Users/tim/Casper/Results/PotentialDuplicates.csv"
let outputNewLeads = "/Users/tim/Casper/Results/NewLeads.csv"

func allExisting() throws -> [HubspotContact] {
    let activeHubspotContacts = try importer
        .hubspotContacts(from: inputAllHubspot)

    let hubspotUnique = Array(Set(activeHubspotContacts))

    let lists500 = Array(Set(try importer.lists500()))

    return hubspotUnique + lists500
}

let casperContacts = CasperV2Process().read(from: inputCasper)

print("Imported \(casperContacts.count).")

let casperConverted = casperContacts.map { CasperV2Mapper(contact: $0).toHubspot }

let result = findPotentialDuplicatesInItself(contacts: casperConverted)

importer.writeHubpostContacts(Array(result.potentialDuplicates), to: outputDuplicatesCasper)

print("Found \(casperConverted.count - result.duplicatesChecked.count) duplicates in imported data.")
print("After duplicates removal remaining:\n\(result.duplicatesChecked.count)")

let casper = result
    .duplicatesChecked
    .sorted(by: {
        func compareNumbersButZero<T>(
            _ keyPath: KeyPath<T, String>,
            _ lhs: T,
            _ rhs: T
        ) -> Bool? {
            let left = Int(lhs[keyPath: keyPath].digits) ?? 0
            let right = Int(rhs[keyPath: keyPath].digits) ?? 0
            
            if left == 0 && right == 0 { return nil }
            
            if left == 0 { return false }
        
            if right == 0 { return true }
            
            return left < right
        }
        
        guard let revenueResult = compareNumbersButZero(\.monthlyRevenue, $0, $1)
        else { return compareNumbersButZero(\.numberOfProducts, $0, $1) ?? false }
        
        return revenueResult
    })

let all = try allExisting()

let potentialDuplicatesResult = findPotentialDuplicates(in: casper, data: all)
print("Found \(potentialDuplicatesResult.potentialDuplicates.count) potential duplicates after comparing with other sources.")
print("After removing potential duplicates from other sources:\n\(potentialDuplicatesResult.duplicatesChecked.count)")

importer.writeHubpostContacts(Array(potentialDuplicatesResult.potentialDuplicates), to: outputPotentialDuplicates)
importer.writeHubpostContacts(Array(potentialDuplicatesResult.duplicatesChecked), to: outputNewLeads)
