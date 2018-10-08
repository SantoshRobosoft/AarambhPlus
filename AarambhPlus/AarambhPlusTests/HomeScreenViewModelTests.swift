//
//  HomeScreenViewModelTests.swift
//  AarambhPlusTests
//
//  Created by Santosh Kumar Sahoo on 10/6/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import XCTest
@testable import AarambhPlus

class HomeScreenViewModelTests: XCTestCase {

    var model: HomeScreenViewModel!
    
    override func setUp() {
        super.setUp()
        let layouts = [Layout(), Layout()]
        model = HomeScreenViewModel(Layout: layouts)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNumberOfSection() {
        let section = model.numberOfSection()
        XCTAssertEqual(section, 2)
    }

}
