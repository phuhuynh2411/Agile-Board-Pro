//
//  IssueController.swift
//  AgileBoardTests
//
//  Created by Huynh Tan Phu on 12/20/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import XCTest
@testable import AgileBoard
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
    
    // MARK: - Increase Serial Number
    
    func testIncreaseSerialNumberCase1() {
        setUpRealm(name: "In-MemeoryRealm")
        let realm = try! Realm()
        IssueController.shared.realm = realm
        
        let issue = IssueController.shared.add(summary: "Todo 1", description: "des 1")
        if let issue = issue {
             XCTAssertEqual(issue.serial, 1, "The serial number should be equal 1")
        }
    }
    
    func testIncreaseSerialNumberCase2() {
        setUpRealm(name: "In-MemeoryRealm")
        let realm = try! Realm()
        try! realm.write{
            realm.deleteAll()
        }
        IssueController.shared.realm = realm
        
        let _ = IssueController.shared.add(summary: "Todo 1", description: "des 1")
        let issue2 = IssueController.shared.add(summary: "Todo 2", description: "des 2")
        if let issue2 = issue2 {
            XCTAssertEqual(issue2.serial, 2, "The serial number should be equal 2")
        }
    }

    func testIncreaseSerialNumberCase3() {
        setUpRealm(name: "In-MemeoryRealm")
        let realm = try! Realm()
        try! realm.write{
            realm.deleteAll()
        }
        IssueController.shared.realm = realm
        
        let _ = IssueController.shared.add(summary: "Todo 1", description: "des 1")
        let _ = IssueController.shared.add(summary: "Todo 2", description: "des 2")
        let issue3 = IssueController.shared.add(summary: "Todo 3", description: "des 3")
        if let issue3 = issue3 {
            XCTAssertEqual(issue3.serial, 3, "The serial number should be equal 2")
        }
    }
    
    // MARK: - Test Issue Id
    
    func testIssueIdCase1() {
        setUpRealm(name: "In-MemeoryRealm")
        let realm = try! Realm()
        try! realm.write{
            realm.deleteAll()
        }
        IssueController.shared.realm = realm
        
        let issue3 = IssueController.shared.add(summary: "Todo 3", description: "des 3")
        let project = Project()
        project.name = "New Project"
        project.key = "NP"
        ProjectController.shared.realm = realm
        ProjectController.shared.add(project: project) {_ in }
        
        if let issue3 = issue3 {
            ProjectController.shared.add(issue: issue3, to: project)
            XCTAssertEqual(issue3.issueID, "NP-1", "The issue ID should be equal NP-1")
        }
    }
    
    func testIssueIdCase2() {
           setUpRealm(name: "In-MemeoryRealm")
           let realm = try! Realm()
           try! realm.write{
               realm.deleteAll()
           }
           IssueController.shared.realm = realm
           
           let _ = IssueController.shared.add(summary: "Todo 3", description: "des 3")
           let issue4 = IssueController.shared.add(summary: "Todo 4", description: "des 4")
           let project = Project()
           project.name = "New Project"
           project.key = "NP"
           ProjectController.shared.realm = realm
           
           
           if let issue4 = issue4 {
               ProjectController.shared.add(issue: issue4, to: project)
               ProjectController.shared.add(project: project) {_ in }
               XCTAssertEqual(issue4.issueID, "NP-2", "The issue ID should be equal NP-2")
           }
       }
    

}
