import Foundation

public class Importer {
    public init() {}
    func readCSV(url: URL, separator: String) throws -> [[String]] {
        try String(contentsOf: url).components(separatedBy: "\n")
            .dropFirst()
            .map { $0.components(separatedBy: separator)
                .map { $0.replacingOccurrences(of: "\"", with: "") } }
    }
    
    public func casperContacts(from path: String) throws -> [CasperContact] {
        
        let url = URL(fileURLWithPath: path)
        
        let lines = try readCSV(url: url, separator: ";")
        
        return lines
            .filter { $0.count > 13 }
            .map(mapRowToCasperContact(row:))
    }
}

enum ParsingError: Error {
    case numberOfColumnsIsLessThanNeeded
}

func mapRowToCasperContact(row: [String]) -> CasperContact {
    CasperContact(
        phone: row[6],
        sellerPage: row[0],
        storeName: row[1],
        businessName: row[4],
        represantativeName: row[5],
        address: row[7],
        country: row[8],
        email: row[9],
        numberOfReviews: row[13]
    )
}




func mutate<T>(_ object: T, closure: (inout T)->Void) -> T {
    var copy = object
    closure(&copy)
    return copy
}

