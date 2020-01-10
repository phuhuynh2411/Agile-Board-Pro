//
//  CalendarExtensionTest.swift
//  CalendarExtensionTest
//
//  Created by Huynh Tan Phu on 1/10/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board

class CalendarExtensionTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThisSundayCase1() {
        let calendar = Calendar.current
        let date = Date()
        let sunday = calendar.thisSunday(date)
        
        XCTAssertEqual(date, sunday, "Two dates should be equal.")
        
    }

}
