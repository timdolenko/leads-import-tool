import Foundation

public class NameMapper {
    
    public init() {}
    
    public enum Failure: Error {
        case notSupportedFormat
        case entityDetected
        case empty
    }
    
    struct Name {
        let first: String
        let last: String
    }
    
    public func process(_ nameRow: String) throws -> HubspotContact.Names {
        guard !(nameRow.lowercased().contains("kein"))
        else { throw Failure.empty }
        
        guard nameRow.count < 70
        else { throw Failure.notSupportedFormat }
        
        guard !nameRow
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        else { throw Failure.empty }
        
        try checkForEntityKeywords(nameRow)
        
        var source = removeBlacklistedWords(from: nameRow)
        
        source = replaceAndWithAmpersant(name: source)
        
        let spaceSplit = source.split(separator: " ").map { String($0) }
        if spaceSplit.count == 4, spaceSplit[1] == "&" {
            return .init(
                first: spaceSplit[0],
                last: spaceSplit[3],
                ceo2First: spaceSplit[2],
                ceo2Last: spaceSplit[3],
                ceo3First: "",
                ceo3Last: ""
            )
        }
        
        source = replaceNameSeparatorWithComa(name: source)
        
        if source.contains(",") {
            let splitedByComa = source.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            
            if splitedByComa.count == 2, !splitedByComa[0].contains(" "), !splitedByComa[1].contains(" ") {
                return .init(first: splitedByComa[0], last: splitedByComa[1])
            }
            
            return map(names: try splitedByComa
                    .flatMap { try processFullName(fullName: String($0)) })
        }
        
        return map(names: try processFullName(fullName: source))
    }
    
    private func checkForEntityKeywords(_ name: String) throws {
        let keywords = [
            " GbR",
            " GmbH",
            " UG (haftungsbeschränkt)"
        ]
        
        for key in keywords {
            if name.contains(key) {
                throw Failure.entityDetected
            }
        }
    }
    
    private func processFullName(fullName: String) throws -> [Name] {
        let splitted = fullName.split(separator: " ")
            .map { String($0) }
        
        if let vonIndex = splitted.firstIndex(of: "von") {
            if vonIndex != 0 && vonIndex == splitted.count - 2 {
                return [.init(first: splitted[0], last: splitted[1...2].joined(separator: " "))]
            } else if let derIndex = splitted.firstIndex(of: "der") {
                if derIndex == vonIndex + 1 {
                    return [.init(first: splitted[0], last: splitted[1...3].joined(separator: " "))]
                }
            }
        }
        
        
        if splitted.count == 4 {
            let first = try processFullName(fullName: splitted[0...1].joined(separator: " "))
            let second = try processFullName(fullName: splitted[2...3].joined(separator: " "))
            return first + second
        }
        
        if splitted.count == 3 {
            if splitted[0] == "Herr" {
                return [.init(first: splitted[1], last: splitted[2])]
            }
            
            return [.init(first: splitted[0...1].joined(separator: " "), last: splitted[2])]
        }
        
        if splitted.count != 2 {
            throw Failure.notSupportedFormat
        }
        
        return [.init(first: splitted[0], last: splitted[1])]
    }
    
    private func map(names: [Name]) -> HubspotContact.Names {
        var result = HubspotContact.Names.init(first: "", last: "")
        
        if names.count > 0 {
            result.first = names[0].first
            result.last = names[0].last
        }
        
        if names.count > 1 {
            result.ceo2First = names[1].first
            result.ceo2Last = names[1].last
        }
        
        if names.count > 2 {
            result.ceo3First = names[2].first
            result.ceo3Last = names[2].last
        }
        
        return result
    }
    
    private func removeBlacklistedWords(from name: String) -> String {
        var source = name
        let blackList = [
            "Geschäftsführer",
            "Geschäftsführung",
            "Geschäftsführender Gesellschaffter",
            "Hr.",
            "Dr.",
            "Prof.",
            "Dipl. Kfm.",
            "Dipl.-Kfm.",
            "Frau",
            "(CEO)",
            "(CCO)",
            "GF ",
            "Inhaber",
            "Ing. ",
            ":"
        ]
        
        for word in blackList {
            source = source.replacingOccurrences(of: word, with: "")
        }
        return source
    }
    
    private func replaceAndWithAmpersant(name: String) -> String {
        var source = name
        let blackList = [
            "u.",
            "und",
        ]
        
        for word in blackList {
            source = source.replacingOccurrences(of: "\(word)", with: "&")
        }
        return source
    }
    
    private func replaceNameSeparatorWithComa(name: String) -> String {
        var source = name
        let blackList = [
            "&",
            "/",
            "+",
            ";"
        ]
        
        for word in blackList {
            source = source.replacingOccurrences(of: " \(word) ", with: ", ")
        }
        return source
    }
}
