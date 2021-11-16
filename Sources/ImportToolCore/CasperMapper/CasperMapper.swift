import Foundation


public class CasperMapper {
    
    private let contact: CasperContact
    
    public init(contact: CasperContact) {
        self.contact = contact
    }
    
    public var names: HubspotContact.Names {
        do {
            return try NameMapper().process(contact.represantativeName)
        } catch {
            return HubspotContact.Names(first: contact.represantativeName, last: "")
        }
    }

    public var address: HubspotContact.Address {
        do {
            return try AddressMapper().process(address: contact.address)
        } catch {
            return HubspotContact.Address(streetAddress: contact.address, zipCode: "", city: "", country: "")
        }
    }

    public var toHubspot: HubspotContact {
        
        return HubspotContact(
            phone: contact.phone.trimmed,
            sellerPage: contact.sellerPage.trimmed,
            storeName: contact.storeName.trimmed,
            businessName: contact.businessName.trimmed,
            ceoNames: names,
            address: address,
            email: contact.email.trimmed,
            numberOfReviews: contact.numberOfReviews.onlyNumberic,
            sourceFile: "Casper-Pack"
        )
    }
}

extension String {
    var trimmed: Self {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var onlyNumberic: Self {
        filter("0123456789".contains)
    }
}
