import Foundation

public class NameMapper {
    
    enum Failure: Error {
        case notSupportedFormat
    }
    
    struct Name {
        let first: String
        let last: String
    }
    
    //Frensch, Klaus
    //Vivien Natalie Bölck
    //Prof. Dr. Jörg S. Heinzelmann
    //Sigrid Klenk Willi Klenk
    //Felix Gassmann, MILD Ventures UG
    //Bernhard Albert Weller
    //Köhler Dieter Tilo
    //Hilke Therese Schebitz
    //Inh. Ute Ledig
    public func process(_ nameRow: String) throws -> HubspotContact.Names {
        var source = removeBlacklistedWords(from: nameRow)
        source = replaceNameSeparatorWithComa(name: source)
        
        if source.contains(",") {
            return map(names: try source.split(separator: ",")
                    .map { try processFullName(fullName: String($0)) })
        }
        
        return map(names: [try processFullName(fullName: source)])
    }
    
    private func processFullName(fullName: String) throws -> Name {
        let splitted = fullName.split(separator: " ")
            .map { String($0) }
        
        if splitted.count != 2 {
            throw Failure.notSupportedFormat
        }
        
        return .init(first: splitted[0], last: splitted[1])
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
            "Herr",
            "Prof.",
            "Dipl. Kfm.",
            "Frau",
            "(CEO)",
            "(CCO)",
            ":"
        ]
        
        for word in blackList {
            source = source.replacingOccurrences(of: word, with: "")
        }
        return source
    }
    
    private func replaceNameSeparatorWithComa(name: String) -> String {
        var source = name
        let blackList = [
            "u.",
            "und",
            "&",
            "/",
            "+"
        ]
        
        for word in blackList {
            source = source.replacingOccurrences(of: " \(word) ", with: ", ")
        }
        return source
    }
}
