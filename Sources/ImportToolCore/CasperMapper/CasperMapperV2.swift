import Foundation


public class CasperV2Mapper {
    
    private let contact: CasperContact_v2
    
    public init(contact: CasperContact_v2) {
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
            return try AddressMapper().process(address: contact.businessAddress)
        } catch {
            return HubspotContact.Address(streetAddress: contact.businessAddress, zipCode: "", city: "", country: "")
        }
    }

    public var toHubspot: HubspotContact {
        
        return HubspotContact(
            phone: contact.phone.trimmed,
            sellerPage: contact.sellerPage.trimmed,
            storeName: contact.storeName.trimmed,
            businessName: contact.businessName
                .trimmed
                .replacingOccurrences(of: "&amp; ", with: "und"),
            ceoNames: names,
            address: address,
            email: contact.email.trimmed,
            numberOfReviews: contact.numberOfReviews.onlyNumberic,
            numberOfProducts: contact.numberOfProductsSold,
            monthlyRevenue: contact.monthlyRevenue,
            sourceFile: "CasperV2-Pack"
        )
    }
}
