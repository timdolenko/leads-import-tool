import Foundation
import XCTest
@testable import ImportToolCore

class AddressMapperTests: XCTestCase {
    
    func testSimpleAddress() {
        let a = try! AddressMapper()
            .process(address: "Ludwigstr. 43|Nidda|63667|DE")
        
        XCTAssertEqual(a.streetAddress, "Ludwigstr. 43")
        XCTAssertEqual(a.city, "Nidda")
        XCTAssertEqual(a.zipCode, "63667")
        XCTAssertEqual(a.country, "DE")
    }
    
    func testSimpleAddress2() {
        let a = try! AddressMapper()
            .process(address: "Oskar- Jäger- Str. 141.1|Köln|NRW|50825|DE")
        
        XCTAssertEqual(a.streetAddress, "Oskar- Jäger- Str. 141.1")
        XCTAssertEqual(a.city, "Köln")
        XCTAssertEqual(a.zipCode, "50825")
        XCTAssertEqual(a.country, "DE")
    }
    
    func testCompanyAddress1() {
        let a = try! AddressMapper()
            .process(address: "Dastro®|Hartenbergstr. 20|Königswinter|53639|DE")
        
        XCTAssertEqual(a.streetAddress, "Hartenbergstr. 20")
        XCTAssertEqual(a.city, "Königswinter")
        XCTAssertEqual(a.zipCode, "53639")
        XCTAssertEqual(a.country, "DE")
    }
    
    func testHouseNumber() {
        let a = try! AddressMapper()
            .process(address: "Busbrookhöhe|67|Hamburg|22159|DE")
        
        XCTAssertEqual(a.streetAddress, "Busbrookhöhe 67")
        XCTAssertEqual(a.city, "Hamburg")
        XCTAssertEqual(a.zipCode, "22159")
        XCTAssertEqual(a.country, "DE")
    }
    
    func testHouseNumberRegion() {
        let a = try! AddressMapper()
            .process(address: "Karlsplatz|4|Ludwigsburg|Baden-Württemberg|71638|DE")
        
        XCTAssertEqual(a.streetAddress, "Karlsplatz 4")
        XCTAssertEqual(a.city, "Ludwigsburg")
        XCTAssertEqual(a.zipCode, "71638")
        XCTAssertEqual(a.country, "DE")
    }
}

