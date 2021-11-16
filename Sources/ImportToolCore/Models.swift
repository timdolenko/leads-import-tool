import Foundation

public struct CasperContact {
    public var phone: String
    public var sellerPage: String
    public var storeName: String
    public var businessName: String
    public var represantativeName: String
    public var address: String
    public var country: String
    public var email: String
    public var numberOfReviews: String
}

public struct HubspotContact {
    public struct Address {
        public var streetAddress: String
        public var zipCode: String
        public var city: String
        public var country: String
    }

    public struct Names {
        internal init(first: String, last: String, ceo2First: String = "", ceo2Last: String = "", ceo3First: String = "", ceo3Last: String = "") {
            self.first = first
            self.last = last
            self.ceo2First = ceo2First
            self.ceo2Last = ceo2Last
            self.ceo3First = ceo3First
            self.ceo3Last = ceo3Last
        }
        
        public var first: String
        public var last: String
        public var ceo2First: String
        public var ceo2Last: String
        public var ceo3First: String
        public var ceo3Last: String
    }
    
    public var phone: String
    public var sellerPage: String
    public var storeName: String
    public var businessName: String
    public var ceoNames: Names
    public var address: Address
    public var email: String
    public var numberOfReviews: String
}

public struct BaseIdentifiableContact {
    public var phone: String
    public var email: String
    public var company: String
    public var firstName: String
    public var lastName: String
}
