import ImportToolCore
print("Hello, world!")


//Duplicate Phone Numbers    Duplicate Email    Duplicate Company    Duplicate Name    Potenzielles Duplikat//

let importer = Importer()
let casperContacts = try importer.casperContacts(from: "/Users/tim/Documents/Hubspot/Casper/CasperTest.csv")

let mapped = casperContacts.map { CasperMapper(contact: $0).names }
for c in mapped {
    print(c.first)
}

let failureCount = mapped.filter { $0.first == "FAILURE" }.count
let percentage: Double = Double(failureCount) / (Double(mapped.count) / 100.0)
print("\(String(format: "%d.%d", (100-percentage).description))% Success")
