import Foundation
import XCTest
@testable import ImportToolCore

class NameMapperTests: XCTestCase {
    
    let mapper = NameMapper()
    
    func testSimpleName() {
        let names = try! mapper.process("Tobias Strohbach")
        
        XCTAssertEqual(names.first, "Tobias")
        XCTAssertEqual(names.last, "Strohbach")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testWithCEOString() {
        let names = try! mapper
            .process("Geschäftsführer: David Wagner")
        
        XCTAssertEqual(names.first, "David")
        XCTAssertEqual(names.last, "Wagner")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testWithCEOString2() {
        let names = try! mapper
            .process("Geschäftsführung Stefan Köper")
        
        XCTAssertEqual(names.first, "Stefan")
        XCTAssertEqual(names.last, "Köper")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test2Coma() {
        let names = try! mapper
            .process("Robert Renai, Mike Friedrich")
        
        XCTAssertEqual(names.first, "Robert")
        XCTAssertEqual(names.last, "Renai")
        XCTAssertEqual(names.ceo2First, "Mike")
        XCTAssertEqual(names.ceo2Last, "Friedrich")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test2Ampersant() {
        let names = try! mapper
            .process("Heike Christos & Stefan Breunig")
        
        XCTAssertEqual(names.first, "Heike")
        XCTAssertEqual(names.last, "Christos")
        XCTAssertEqual(names.ceo2First, "Stefan")
        XCTAssertEqual(names.ceo2Last, "Breunig")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test3Comma() {
        let names = try! mapper
            .process("Manuel Ponska, Robert Tittel-Mokawietz, Gernold Lippmann")
        
        XCTAssertEqual(names.first, "Manuel")
        XCTAssertEqual(names.last, "Ponska")
        XCTAssertEqual(names.ceo2First, "Robert")
        XCTAssertEqual(names.ceo2Last, "Tittel-Mokawietz")
        XCTAssertEqual(names.ceo3First, "Gernold")
        XCTAssertEqual(names.ceo3Last, "Lippmann")
    }
    
    func test2Und() {
        let names = try! mapper
            .process("Rene Andresen und Axel Dolenko")
        
        XCTAssertEqual(names.first, "Rene")
        XCTAssertEqual(names.last, "Andresen")
        XCTAssertEqual(names.ceo2First, "Axel")
        XCTAssertEqual(names.ceo2Last, "Dolenko")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test2Salutation1() {
        let names = try! mapper
            .process("Hr. Philipp Türk & Hr. Markus Pfinzer")
        
        XCTAssertEqual(names.first, "Philipp")
        XCTAssertEqual(names.last, "Türk")
        XCTAssertEqual(names.ceo2First, "Markus")
        XCTAssertEqual(names.ceo2Last, "Pfinzer")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }

    func test2Salutation2() {
        let names = try! mapper
            .process("Dr. Joachen Neemann, Volkmart Döring")

        XCTAssertEqual(names.first, "Joachen")
        XCTAssertEqual(names.last, "Neemann")
        XCTAssertEqual(names.ceo2First, "Volkmart")
        XCTAssertEqual(names.ceo2Last, "Döring")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }

    func test2Salutation3() {
        let names = try! mapper
            .process("Herr Markus Kourtaliosi")

        XCTAssertEqual(names.first, "Markus")
        XCTAssertEqual(names.last, "Kourtaliosi")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }

    func test2Salutation4() {
        let names = try! mapper
            .process("Dr. M. Herfald, M. Parske, M. Agbers")

        XCTAssertEqual(names.first, "M.")
        XCTAssertEqual(names.last, "Herfald")
        XCTAssertEqual(names.ceo2First, "M.")
        XCTAssertEqual(names.ceo2Last, "Parske")
        XCTAssertEqual(names.ceo3First, "M.")
        XCTAssertEqual(names.ceo3Last, "Agbers")
    }
    
    func testVon() {
        let names = try! mapper.process("Sven von Haarp")
        
        XCTAssertEqual(names.first, "Sven")
        XCTAssertEqual(names.last, "von Haarp")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test2UndVon() {
        let names = try! mapper
            .process("Rene Andresen und Sven von Haarp")
        
        XCTAssertEqual(names.first, "Rene")
        XCTAssertEqual(names.last, "Andresen")
        XCTAssertEqual(names.ceo2First, "Sven")
        XCTAssertEqual(names.ceo2Last, "von Haarp")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testVonDer() {
        let names = try! mapper.process("Sven von der Haarp")
        
        XCTAssertEqual(names.first, "Sven")
        XCTAssertEqual(names.last, "von der Haarp")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test3WordName() {
        let names = try! mapper.process("Fritz Michael Henrich")
        
        XCTAssertEqual(names.first, "Fritz Michael")
        XCTAssertEqual(names.last, "Henrich")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test4WordName() {
        let names = try! mapper.process("Dieter Frank Nikola Frank")
        
        XCTAssertEqual(names.first, "Dieter")
        XCTAssertEqual(names.last, "Frank")
        XCTAssertEqual(names.ceo2First, "Nikola")
        XCTAssertEqual(names.ceo2Last, "Frank")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testNameComa() {
        let names = try! mapper.process("Inhaber: Matthias, Frank")
        
        XCTAssertEqual(names.first, "Matthias")
        XCTAssertEqual(names.last, "Frank")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testFamily() {
        let names = try! mapper.process("Patrick & Matthias Böckmann")
        
        XCTAssertEqual(names.first, "Patrick")
        XCTAssertEqual(names.last, "Böckmann")
        XCTAssertEqual(names.ceo2First, "Matthias")
        XCTAssertEqual(names.ceo2Last, "Böckmann")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testFamily2() {
        let names = try! mapper.process("Karin und Patrick Hallingers")
        
        XCTAssertEqual(names.first, "Karin")
        XCTAssertEqual(names.last, "Hallingers")
        XCTAssertEqual(names.ceo2First, "Patrick")
        XCTAssertEqual(names.ceo2Last, "Hallingers")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
}



