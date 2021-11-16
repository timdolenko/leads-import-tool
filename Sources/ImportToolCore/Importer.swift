import Foundation

public class Importer {
    public init() {}
    
    public func casperContacts(from path: String) throws -> [CasperContact] {
        try readCSV(path: path, separator: ";")
            .filter { $0.count > 13 }
            .map(mapRowToCasperContact(row:))
    }
    
    public func hubspotContacts(from path: String) throws -> [HubspotContact] {
        try readCSV(path: path, separator: ",")
            .filter { $0.count > 17 }
            .enumerated()
            .map { mapHubspotRowToHubspotContact(row: $0.element, line: $0.offset) }
    }
    
    private func list500(from path: String) throws -> [HubspotContact] {
        try readCSV(path: path, separator: ",")
            .filter { $0.count > 23 }
            .enumerated()
            .map { map500RowToHubspotContact(row: $0.element, filename: path, line: $0.offset) }
    }
    
    public func lists500() throws -> [HubspotContact] {
        let directory = "/Users/tim/Casper/500/converted/"
        let files: [String] = (1...25).map { "\($0).csv" } + ["7-1.csv"]
        
        return try files
            .map { directory + $0 }
            .flatMap { try list500(from: $0) }
    }
    
    private func readCSV(path: String, separator: String) throws -> [[String]] {
        let url = URL(fileURLWithPath: path)
        
        return try readCSV(url: url, separator: separator)
    }
    
    private func readCSV(url: URL, separator: String) throws -> [[String]] {
        try String(contentsOf: url).components(separatedBy: "\n")
            .dropFirst()
            .map { $0.components(separatedBy: separator)
                .map { $0.replacingOccurrences(of: "\"", with: "") } }
    }
}

extension Importer {
    public func writeHubpostContacts(_ contacts: [HubspotContact], to path: String) {
        var csv = ""
        
        let header = "Lead-Quelle;Vorname;Nachname;GF2 Vorname;GF2 Nachname;GF3 Vorname;GF3 Nachname;Telefonnummer;E-Mail;Händlerseite URL;Account-Name (Amazon);Unternehmensname;Adresszeile;PLZ;Stadt;Land/Region;Anzahl der Händlerbewertungen;Source\n"
        
        csv += header
        
        for c in contacts {
            
            let row = "DMC;\(c.ceoNames.first);\(c.ceoNames.last);\(c.ceoNames.ceo2First);\(c.ceoNames.ceo2Last);\(c.ceoNames.ceo3First);\(c.ceoNames.ceo3Last);\(c.phone);\(c.email); \(c.sellerPage);\(c.storeName);\(c.businessName);\(c.address.streetAddress);\(c.address.zipCode);\(c.address.city);\(c.address.country);\(c.numberOfReviews);\(c.sourceFile)\n"
            csv += row
        }
        
        do {
            try csv.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

