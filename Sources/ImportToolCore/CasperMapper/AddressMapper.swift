import Foundation

class AddressMapper {
    
    func map(address: String) -> HubspotContact.Address {
        var splitted = address.split(separator: "|").map { String($0) }
        if let first = splitted.first, !first.contains("str") {
            
        }
        
        let states = [
            "Baden-Württemberg",
            "Bayern",
            "Berlin",
            "Bremen",
            "Hamburg",
            "Hessen",
            "Mecklenburg-Vorpommern",
            "Niedersachsen",
            "Nordrhein-Westfalen",
            "Rheinland-Pfalz",
            "Saarland",
            "Sachsen",
            "Sachsen-Anhalt",
            "Schleswig-Holstein",
            "Thüringen"
        ]
        
        return .init(
            streetAddress: splitted[0],
            zipCode: splitted.reversed()[1],
            city: splitted[1],
            country: splitted.reversed()[0]
        )
    }
}
