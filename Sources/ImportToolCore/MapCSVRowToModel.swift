import Foundation

public func mapRowToCasperV2Contact(row: [String]) -> CasperContact_v2 {
    CasperContact_v2(
        sellerPage: row[0],
        businessName: row[1],
        represantativeName: row[2],
        businessAddress: row[3],
        country: row[4],
        zip: row[5],
        state: row[6],
        city: row[7],
        streetAddress: row[8],
        storeName: row[9],
        email: row[10],
        phone: row[11],
        starRating: row[12],
        percentagePositiveScore: row[13],
        numberOfReviews: row[17],
        numberOfProductsSold: row[18],
        monthlyRevenue: row[20]
    )
}

public func mapRowToCasperContact(row: [String]) -> CasperContact {
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

public func mapHubspotRowToHubspotContact(row: [String], line: Int) -> HubspotContact {
    HubspotContact(
        phone: row[4],
        sellerPage: row[5],
        storeName: row[6],
        businessName: row[7],
        ceoNames: .init(
            first: row[1],
            last: row[2],
            ceo2First: row[8],
            ceo2Last: row[9],
            ceo3First: row[10],
            ceo3Last: row[11]
        ),
        address: .init(
            streetAddress: row[13],
            zipCode: row[14],
            city: row[15],
            country: row[16]
        ),
        email: row[3],
        numberOfReviews: row[17],
        numberOfProducts: "",
        monthlyRevenue: "",
        sourceFile: "hubspot-all #\(line)"
    )
}

public func map500RowToHubspotContact(row: [String], filename: String, line: Int) -> HubspotContact {
    HubspotContact(
        phone: row[8],
        sellerPage: row[10],
        storeName: row[17],
        businessName: row[18],
        ceoNames: .init(
            first: row[2],
            last: row[3],
            ceo2First: row[4],
            ceo2Last: row[5],
            ceo3First: row[6],
            ceo3Last: row[7]
        ),
        address: .init(
            streetAddress: row[20],
            zipCode: row[21],
            city: row[22],
            country: row[23]
        ),
        email: row[9],
        numberOfReviews: row[24],
        numberOfProducts: row[11],
        monthlyRevenue: "",
        sourceFile: filename + " #\(line)"
    )
}
