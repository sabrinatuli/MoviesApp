//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by Sabrina Tuli on 5/7/21.
//

import XCTest
@testable
import MoviesApp
class MoviesAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let manager = MoviesViewModel()
            XCTAssertTrue(manager.movData.count == 0, "Start with empty Movie list")
            manager.addItem()
            XCTAssertTrue(manager.movData.count == 1, "Should have one Movie afer adding")
            manager.addItem()
            manager.addItem() // added 3 movie
            manager.delete(at: [1])
            XCTAssertTrue(manager.movData.count == 2, "Should have 2 items in Movie list")
        
    }


}
