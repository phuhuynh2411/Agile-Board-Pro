//
//  IssueController.swift
//  AgileBoardTests
//
//  Created by Huynh Tan Phu on 12/20/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import XCTest
@testable import Agile_Board
import RealmSwift

class IssueControllerTest: XCTestCase {
    
    func setUpRealm(name: String, readOnly: Bool = false) {
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
        Realm.Configuration.defaultConfiguration.readOnly = readOnly
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

}
