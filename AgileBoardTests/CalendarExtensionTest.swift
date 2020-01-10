//
//  CalendarExtensionTest.swift
//  Agile BoardTests
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
        print("Date: \(date)")
        print("Sunday: \(sunday)")
        
        let inputSunday = calendar.date(byAdding: .day, value: 2, to: date)
        
        XCTAssertEqual(inputSunday, sunday, "The two dates must be equal.")
        
    }
    
    func testThisSundayCase2() {
        let calendar = Calendar.current
        var date = Date()
        date = calendar.date(byAdding: .day, value: -2, to: date)!
        let sunday = calendar.thisSunday(date)
        print("Date: \(date)")
        print("Sunday: \(sunday)")
        
        let inputSunday = calendar.date(byAdding: .day, value: 4, to: date)
        
        XCTAssertEqual(inputSunday, sunday, "The two dates must be equal.")
        
    }
    
    func testDateInThisWeekCase1() {
        let calendar = Calendar.current
        var date = Date()
        date = calendar.date(byAdding: .day, value: 1, to: date)!
        print("Week number: \(calendar.component(.weekOfYear, from: date))")
        print("Date: \(date)")
        
        XCTAssertTrue(calendar.isDateInThisWeek(date), "The date must be in this week.")
    }

}
