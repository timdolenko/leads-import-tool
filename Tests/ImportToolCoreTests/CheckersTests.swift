import Foundation
import XCTest
@testable import ImportToolCore

func mutate<T>(_ obj: T, _ closure: (inout T)->Void) -> T {
    var obj = obj
    closure(&obj)
    return obj
}

extension HubspotContact {
    static var mock: Self {
        HubspotContact(
            phone: "",
            sellerPage: "",
            storeName: "",
            businessName: "",
            ceoNames: .init(first: "", last: ""),
            address: .init(streetAddress: "", zipCode: "", city: "", country: ""),
            email: "",
            numberOfReviews: "",
            numberOfProducts: "",
            monthlyRevenue: "",
            sourceFile: ""
        )
    }
}

class CheckersTests: XCTestCase {
    
    func testPhones() {
        
        let c1 = mutate(HubspotContact.mock) {
            $0.phone = "051"
        }

        let c2 = mutate(HubspotContact.mock) {
            $0.phone = "051"
        }

        let c3 = mutate(HubspotContact.mock) {
            $0.phone = "351"
        }

        let r = findPotentialDuplicatesInItself(contacts: [c1,c2,c3])

        XCTAssertEqual(r.duplicatesChecked.count, 2)
    }
    
    func testEmails() {
        
        let c1 = mutate(HubspotContact.mock) {
            $0.email = "mock@gmail.com"
        }

        let c2 = mutate(HubspotContact.mock) {
            $0.email = "mock@gmail.com"
        }

        let c3 = mutate(HubspotContact.mock) {
            $0.email = "mock1@gmail.com"
        }
        
        let c4 = mutate(HubspotContact.mock) {
            $0.email = ""
        }

        let r = findPotentialDuplicatesInItself(contacts: [c1,c2,c3, c4])

        let notDuplicates = r.duplicatesChecked.sorted(by: { $0.email < $1.email })
        
        XCTAssertEqual(notDuplicates.count, 3)
        XCTAssertEqual(notDuplicates[0].email, "")
        XCTAssertEqual(notDuplicates[1].email, "mock1@gmail.com")
        XCTAssertEqual(notDuplicates[2].email, "mock@gmail.com")
    }
    
    func testEmailPhones() {
        
        let c1 = mutate(HubspotContact.mock) {
            $0.email = "mock@gmail.com"
            $0.phone = "051"
        }

        let c2 = mutate(HubspotContact.mock) {
            $0.email = "mock@gmail.com"
            $0.phone = "051"
        }

        let c3 = mutate(HubspotContact.mock) {
            $0.email = "mock1@gmail.com"
            $0.phone = "051"
        }
        
        let c4 = mutate(HubspotContact.mock) {
            $0.email = ""
            $0.phone = "351"
        }

        let r = findPotentialDuplicatesInItself(contacts: [c1,c2,c3, c4])

        let notDuplicates = r.duplicatesChecked.sorted(by: { $0.email < $1.email })
        
        XCTAssertEqual(notDuplicates.count, 2)
        XCTAssertEqual(notDuplicates[0].email, "")
        XCTAssertEqual(notDuplicates[1].email, "mock@gmail.com")
    }
}
