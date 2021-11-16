import Foundation


public class CasperMapper {
    
    private let contact: CasperContact
    
    public init(contact: CasperContact) {
        self.contact = contact
    }
    
    public var names: HubspotContact.Names {
        if contact.represantativeName.isEmpty { return .init(first: "", last: "") }
        
        do {
            return try NameMapper().process(contact.represantativeName)
        } catch {
            print("❌ Failed to parse name: \(contact.represantativeName)")
            return HubspotContact.Names(first: "FAILURE", last: contact.represantativeName)
        }
    }

    public var address: HubspotContact.Address {
        AddressMapper().map(address: contact.address)
    }

    public var toHubspot: HubspotContact {
        
        return HubspotContact(
            phone: contact.phone,
            sellerPage: contact.sellerPage,
            storeName: contact.storeName,
            businessName: contact.businessName,
            ceoNames: names,
            address: address,
            email: contact.email,
            numberOfReviews: contact.numberOfReviews
        )
    }
}
