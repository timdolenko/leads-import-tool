import Foundation

public enum DuplicateDetector: String, CaseIterable {
    case phone
    case email
    case business
    case store
    case name
    
    var transform: (HubspotContact) -> String {
        switch self {
        case .phone:
            return { $0.phone.filter("0123456789".contains) }
        case .email:
            return { $0.email.trimmingCharacters(in: .whitespacesAndNewlines) }
        case .business:
            return { $0.businessName + " " + $0.address.zipCode }
        case .store:
            return { $0.storeName + " " + $0.address.zipCode }
        case .name:
            return { $0.ceoNames.first + " " + $0.ceoNames.last + " " + $0.address.zipCode  }
        }
    }
}

public class CheckerAgainstItself {
    public init(detector: DuplicateDetector) {
        self.detector = detector
    }
    
    let detector: DuplicateDetector
    var result: [String: [(Int, HubspotContact)]] = [:]
    var nonParticipants: [HubspotContact] = []
    var transform: (HubspotContact)->String { detector.transform }
    
    func run(with source: [HubspotContact]) {
        var dict = [String: [(Int, HubspotContact)]]()
    
        for (index, contact) in source.enumerated() {
            let key = transform(contact).trimmingCharacters(in: .whitespacesAndNewlines)
            if key.isEmpty {
                nonParticipants.append(contact)
            } else {
                if dict[key] == nil {
                    dict[key] = []
                }
                
                dict[key]?.append((index, contact))
            }
        }
        
        result = dict
    }
    
    func duplicates() -> [[HubspotContact]] {
        var r = [[HubspotContact]]()
        for (key, value) in result {
            if value.count > 1 {
                
                let duplicateArray = value
                    .map { $0.1 }
                    .map { contact -> HubspotContact in
                    var c = contact
                    c.sourceFile = detector.rawValue + ": " + key
                    return c
                }
                
                r.append(duplicateArray)
            }
        }
        
        return r
    }
    
    func nonDuplicates() -> [HubspotContact] {
        nonParticipants + result.values.map { $0.first!.1 }
    }
}

public struct PotentialDuplicatesResult {
    public var potentialDuplicates: [HubspotContact] = []
    public var duplicatesChecked: [HubspotContact] = []
}

public func findPotentialDuplicatesInItself(contacts: [HubspotContact]) -> PotentialDuplicatesResult {
    var result = PotentialDuplicatesResult()
    result.duplicatesChecked = contacts
    
    let checkersAgainstItself = DuplicateDetector.allCases
        .map { CheckerAgainstItself(detector: $0) }

    for checker in checkersAgainstItself {
        checker.run(with: result.duplicatesChecked)
        
        result.potentialDuplicates
            .append(
                contentsOf: checker.duplicates().flatMap { $0 }
            )
        
        result.duplicatesChecked = checker.nonDuplicates()
    }
    
    return result
}

public class Checker {
    public init(source: [HubspotContact], detector: DuplicateDetector) {
        self.detector = detector
        self.setupCheckDictionary(with: source)
    }
    
    public let detector: DuplicateDetector
    public var checkDictionary: [String: HubspotContact] = [:]
    public var transform: (HubspotContact)->String { detector.transform }
    
    func duplicate(_ contact: HubspotContact) -> HubspotContact? {
        let key = transform(contact).trimmingCharacters(in: .whitespacesAndNewlines)
        if key.isEmpty {
            return nil
        }
        
        return checkDictionary[transform(contact)]
    }
    
    func setupCheckDictionary(with source: [HubspotContact]) {
        var dict = [String: HubspotContact]()
        
        for contact in source {
            let key = transform(contact).trimmingCharacters(in: .whitespacesAndNewlines)
            if key.isEmpty { continue }
            
            dict[key] = contact
        }
        
        checkDictionary = dict
    }
}

public func findPotentialDuplicates(in array: [HubspotContact], data: [HubspotContact]) -> PotentialDuplicatesResult {
    
    let checkers = DuplicateDetector.allCases.map { Checker(source: data, detector: $0) }

    var result = PotentialDuplicatesResult()
    
    outerLoop: for var contact in array {
        
        for checker in checkers {
            if let d = checker.duplicate(contact) {
                contact.sourceFile = checker.detector.rawValue + " " + d.sourceFile
                result.potentialDuplicates.append(contact)
                continue outerLoop
            }
        }
        
        result.duplicatesChecked.append(contact)
    }
    
    return result
}
