import Foundation
import CSV

public class CasperV2Process {
    public init() {}
    public func read(from path: String) -> [CasperContact_v2] {
        let stream = InputStream(fileAtPath: path)!
        let csv = try! CSVReader(stream: stream, hasHeaderRow: true, trimFields: true, delimiter: ";")

        var contacts: [CasperContact_v2] = []
        
        while let row = csv.next() {
            
            let contact = mapRowToCasperV2Contact(row: row)
            
            guard ["DE", "AT", "CH"].contains(contact.country) else { continue }
            
            guard (contact.phone.digits.count > 5) else { continue }
            
            contacts.append(contact)
        }
        
        return contacts
    }
    
    public func write(to path: String, _ contacts: [HubspotContact]) {
        let stream = OutputStream(toFileAtPath: path, append: false)!
        let csv = try! CSVWriter(stream: stream, delimiter: ";", newline: .crlf)
        
        let header = [
            "Lead-Quelle",
            "Vorname",
            "Nachname",
            "GF2 Vorname",
            "GF2 Nachname",
            "GF3 Vorname",
            "GF3 Nachname",
            "Telefonnummer",
            "E-Mail",
            "Händlerseite URL",
            "Account-Name (Amazon)",
            "Unternehmensname",
            "Adresszeile",
            "PLZ",
            "Stadt",
            "Land/Region",
            "Anzahl der Händlerbewertungen",
            "Anzahl der Produkte",
            "Monatlicher Umsatz",
            "Source"
        ]
        
        try! csv.write(row: header)
        
        for c in contacts {
            
            let row = [
                "DMC",
                c.ceoNames.first,
                c.ceoNames.last,
                c.ceoNames.ceo2First,
                c.ceoNames.ceo2Last,
                c.ceoNames.ceo3First,
                c.ceoNames.ceo3Last,
                c.phone,
                c.email,
                c.sellerPage,
                c.storeName,
                c.businessName,
                c.address.streetAddress,
                c.address.zipCode,
                c.address.city,
                c.address.country,
                c.numberOfReviews,
                c.numberOfProducts,
                c.monthlyRevenue,
                c.sourceFile
            ]
            
            try! csv.write(row: row)
        }
        
        csv.stream.close()
    }
}

public extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
