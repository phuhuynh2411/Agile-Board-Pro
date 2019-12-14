//
//  AddIssueTableViewControllerTest.swift
//  AgileBoardTests
//
//  Created by Huynh Tan Phu on 12/14/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import XCTest
import RealmSwift
@testable import AgileBoard

class AddIssueTableViewControllerTest: XCTestCase {
    
    var sut: AddIssueTableViewController!

    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyBoard.instantiateViewController(withIdentifier: "AddIssueTableViewController") as? AddIssueTableViewController
        sut.loadView()
        sut.viewDidLoad()
        sut.viewDidLayoutSubviews()
    
    }
    
    func setUpRealm(name: String, readOnly: Bool = false) {
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
        Realm.Configuration.defaultConfiguration.readOnly = readOnly
    }

    override func tearDown() {
        sut = nil
    }

    // MARK: - IsNew Test Cases
    
    // Issue is not in realm database
    // Expeted result: true
    func testIsNewCase2() {
        setUpRealm(name: "In-MemoryRealm")
        let realm = try! Realm()
        
        IssueController.shared.realm = realm
        
        let issue = Issue()
        sut.issue = issue
        
        XCTAssertTrue(sut.isNew(), "The issue was in realm database.")
    }
    
    // Issue is in the realm database
    // Expected result: false
    func testIsNewCase1() {
        setUpRealm(name: "In-MemoryRealm")
        let realm = try! Realm()
        
        IssueController.shared.realm = realm
        
        let issue = Issue()
        IssueController.shared.add(issue: issue)
        let addedIssue = realm.objects(Issue.self).first
        sut.issue = addedIssue
        
        XCTAssertFalse(sut.isNew(), "Issue is in realm database. It should return false.")
    }
    
    // Issue is nil. It means that it is not in realm database.
    // Expected result: true
    func testIsNewCase3() {
        setUpRealm(name: "In-MemoryRealm")
        let realm = try! Realm()
        
        IssueController.shared.realm = realm
        
        sut.issue = nil
                
        XCTAssertTrue(sut.isNew(), "The issue was in realm database.")
    }
   

}
