import Foundation
import XCTest
@testable import ImportToolCore

class NameMapperTests: XCTestCase {
    
    let mapper = NameMapper()
    
    func testSimpleName() {
        let names = try! mapper.process("Tobias Wagner")
        
        XCTAssertEqual(names.first, "Tobias")
        XCTAssertEqual(names.last, "Wagner")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testWithCEOString() {
        let names = try! mapper
            .process("Geschäftsführer: David Strohbach")
        
        XCTAssertEqual(names.first, "David")
        XCTAssertEqual(names.last, "Strohbach")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func testWithCEOString2() {
        let names = try! mapper
            .process("Geschäftsführung Steffen Köper")
        
        XCTAssertEqual(names.first, "Steffen")
        XCTAssertEqual(names.last, "Köper")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test2Coma() {
        let names = try! mapper
            .process("Robert Rónai, Maik Friedrich")
        
        XCTAssertEqual(names.first, "Robert")
        XCTAssertEqual(names.last, "Rónai")
        XCTAssertEqual(names.ceo2First, "Maik")
        XCTAssertEqual(names.ceo2Last, "Friedrich")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test2Ampersant() {
        let names = try! mapper
            .process("Heike Christ & Steffen Breunig")
        
        XCTAssertEqual(names.first, "Heike")
        XCTAssertEqual(names.last, "Christ")
        XCTAssertEqual(names.ceo2First, "Steffen")
        XCTAssertEqual(names.ceo2Last, "Breunig")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test3Comma() {
        let names = try! mapper
            .process("Manuel Monska, Robert Tittel-Morawietz, Gernot Lippmann")
        
        XCTAssertEqual(names.first, "Manuel")
        XCTAssertEqual(names.last, "Monska")
        XCTAssertEqual(names.ceo2First, "Robert")
        XCTAssertEqual(names.ceo2Last, "Tittel-Morawietz")
        XCTAssertEqual(names.ceo3First, "Gernot")
        XCTAssertEqual(names.ceo3Last, "Lippmann")
    }
    
    func test2Und() {
        let names = try! mapper
            .process("Rene Andresen und Axel Roemersma")
        
        XCTAssertEqual(names.first, "Rene")
        XCTAssertEqual(names.last, "Andresen")
        XCTAssertEqual(names.ceo2First, "Axel")
        XCTAssertEqual(names.ceo2Last, "Roemersma")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }
    
    func test2Salutation1() {
        let names = try! mapper
            .process("Hr. Philipp Török & Hr. Markus Pinetz")
        
        XCTAssertEqual(names.first, "Philipp")
        XCTAssertEqual(names.last, "Török")
        XCTAssertEqual(names.ceo2First, "Markus")
        XCTAssertEqual(names.ceo2Last, "Pinetz")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }

    func test2Salutation2() {
        let names = try! mapper
            .process("Dr. Jochen Heemann, Volkmar Döring")

        XCTAssertEqual(names.first, "Jochen")
        XCTAssertEqual(names.last, "Heemann")
        XCTAssertEqual(names.ceo2First, "Volkmar")
        XCTAssertEqual(names.ceo2Last, "Döring")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }

    func test2Salutation3() {
        let names = try! mapper
            .process("Herr Markos Kourtalios")

        XCTAssertEqual(names.first, "Markos")
        XCTAssertEqual(names.last, "Kourtalios")
        XCTAssertEqual(names.ceo2First, "")
        XCTAssertEqual(names.ceo2Last, "")
        XCTAssertEqual(names.ceo3First, "")
        XCTAssertEqual(names.ceo3Last, "")
    }

    func test2Salutation4() {
        let names = try! mapper
            .process("Dr. M. Herfeld, M. Perske, M. Egbers")

        XCTAssertEqual(names.first, "M.")
        XCTAssertEqual(names.last, "Herfeld")
        XCTAssertEqual(names.ceo2First, "M.")
        XCTAssertEqual(names.ceo2Last, "Perske")
        XCTAssertEqual(names.ceo3First, "M.")
        XCTAssertEqual(names.ceo3Last, "Egbers")
    }
    
//    func testLongName() {
//        let names = try! mapper.process("Fabian Tobias Blocher")
//
//        XCTAssertEqual(names.first, "M.")
//        XCTAssertEqual(names.last, "Herfeld")
//        XCTAssertEqual(names.ceo2First, "M.")
//        XCTAssertEqual(names.ceo2Last, "Perske")
//        XCTAssertEqual(names.ceo3First, "M.")
//        XCTAssertEqual(names.ceo3Last, "Egbers")
//    }
    
    //Frensch, Klaus
    //Vivien Natalie Bölck
    //Prof. Dr. Jörg S. Heinzelmann
    //Sigrid Klenk Willi Klenk
    //Felix Gassmann, MILD Ventures UG
    //Bernhard Albert Weller
    //Köhler Dieter Tilo
    //Hilke Therese Schebitz
    //Inh. Ute Ledig
    func testShouldThrowIfFormatUnsupported() {
        let mapper = NameMapper()
        
        XCTAssertThrowsError(try mapper.process("Frensch, Klaus"))
    }
}



