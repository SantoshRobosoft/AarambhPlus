//
//  StringExtensionTests.swift
//  AarambhPlusTests
//
//  Created by Santosh Kumar Sahoo on 10/6/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import XCTest
@testable import AarambhPlus

class StringExtensionTests: XCTestCase {

    let string = "test"
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStringLength() {
        let length = string.length
        XCTAssertTrue(length == 4)
    }

    /*
     // Test Cases:
     // Success: "t", "te", "test"
     // Failed: "T", "test ", "ts"
    */
    func testBeginWithCharacters() {
        XCTAssertTrue(string.beginsWith("te"))
    }
    
    /*
     // Test cases :
     // Success: "12", "12 ", "12 2"
     // Failed: "1h"
    */
    func testIsNumeric() {
        XCTAssertTrue("12 2 ".isNumericVal())
    }
    
    /*
     // Test cases :
     // Success: "8909876895"
     // Failed: ""89098","8908r","890987689545"
     */
    func testIsValidModileNumber() {
        XCTAssertTrue("8909876890".isValidMobileNumber())
    }
}
