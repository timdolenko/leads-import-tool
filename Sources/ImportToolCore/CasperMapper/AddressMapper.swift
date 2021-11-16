import Foundation

public class AddressMapper {
    
    public init() {}
    
    public enum Failure: Error {
        case empty
        case notSupportedFormat
    }
    
    public func process(address: String) throws -> HubspotContact.Address {
        var splitted = address.split(separator: "|").map { String($0) }
        
        guard !splitted.isEmpty
        else { throw Failure.empty }
                
        let country = try extractCountry(from: &splitted)
        let zipCode = try extractZipCode(from: &splitted)
        
        if country == "DE" {
            removeGermanState(from: &splitted)
        } else if country == "AT" {
            removeAustrianState(from: &splitted)
        }
        
        guard !splitted.isEmpty else {
            throw Failure.notSupportedFormat
        }
        
        if splitted.last!.count < 3 {
            _ = splitted.popLast()
        }
        
        let city = splitted.popLast()!
        
        var streetAddress: String = ""
        streetLoop: for (index, part) in splitted.enumerated() {
            let streetKeywords = [
                "allee",
                "str.",
                "straße",
                "strasse",
                "Strasse",
                "Straße",
                "Str.",
                "weg ",
                "Weg",
                "Auf der ",
                "Am ",
                "markt",
                "Im ",
                "Zum ",
                "Str ",
                "Zur ",
                "platz ",
                "-Str"
            ]
            
            for keyword in streetKeywords {
                if part.contains(keyword) {
                    streetAddress = part
                    splitted.remove(at: index)
                    break streetLoop
                }
            }
        }
        
        if !streetAddress.contains(where: { $0.isNumber }) {
            for (index, part) in splitted.enumerated() {
                if part.contains(where: { $0.isNumber }) {
                    if !streetAddress.isEmpty {
                        streetAddress += " "
                    }
                    streetAddress += part
                    splitted.remove(at: index)
                    break
                }
            }
        }
        
        if isHouseNumber(string: streetAddress) {
            streetAddress = "\(splitted.remove(at: 0)) \(streetAddress)"
        }
        
        return .init(
            streetAddress: streetAddress,
            zipCode: zipCode,
            city: city,
            country: country
        )
    }
    
    func isHouseNumber(string: String) -> Bool {
        string.trimmingCharacters(in: .decimalDigits).count < 2
    }
    
    func extractCountry(from address: inout [String]) throws -> String {
        let country = address.popLast()!
        guard country.count == 2
        else { throw Failure.notSupportedFormat }
        return country
    }
    
    func extractZipCode(from address: inout [String]) throws -> String {
        let zipCode = address.popLast()!
        guard zipCode.count >= 4, zipCode.isNumeric
        else { throw Failure.notSupportedFormat }
        return zipCode
    }
    
    func removeStates(from address: inout [String], states: [String], cityStates: [String]) {
        for state in states {
            guard let index = address.firstIndex(of: state) else { continue }
            address.remove(at: index)
            break
        }
        
        var memory: [String: Bool] = [:]
        
        addressLoop: for (index, part) in address.enumerated() {
            for state in cityStates {
                if part == state {
                    if let _ = memory[state] {
                        address.remove(at: index)
                        break addressLoop
                    } else {
                        memory[state] = true
                    }
                }
            }
        }
    }
    
    func removeAustrianState(from address: inout [String]) {
        removeStates(from: &address, states: [
            "Österreich",
            "Burgen­land",
            "Ober­österreich",
            "Kärnten",
            "Nieder­österreich",
            "Salzburg",
            "Steier­mark",
            "Tirol",
            "Vorarl­berg"
        ], cityStates: [
            "Wien"
        ])
    }
    
    func removeGermanState(from address: inout [String]) {
        removeStates(from: &address, states: [
            "Deutschland",
            "Baden-Württemberg",
            "Bayern",
            "Hessen",
            "Mecklenburg-Vorpommern",
            "Niedersachsen",
            "Nordrhein-Westfalen",
            "Rheinland-Pfalz",
            "Rheinland Pfalz",
            "Saarland",
            "Sachsen",
            "Sachsen-Anhalt",
            "Schleswig-Holstein",
            "Thüringen",
            "NRW",
            "( Bayern )",
            "BW"
        ], cityStates: [
            "Berlin",
            "Bremen",
            "Hamburg"
        ])
    }
}

extension String {
   var isNumeric: Bool {
     return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
   }
}
