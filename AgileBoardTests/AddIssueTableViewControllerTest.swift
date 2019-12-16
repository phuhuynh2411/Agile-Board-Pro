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
    
    var sut: IssueDetailTableViewController!

    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyBoard.instantiateViewController(withIdentifier: "AddIssueTableViewController") as? IssueDetailTableViewController
        sut.loadViewIfNeeded()
        //sut.loadView()
        //sut.viewDidLoad()
        //sut.viewDidLayoutSubviews()
        UIApplication.shared.keyWindow?.rootViewController = sut
    
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
        sut.initView(with: issue, and: nil)
        
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
        sut.initView(with: addedIssue!, and: nil)
        
        XCTAssertFalse(sut.isNew(), "Issue is in realm database. It should return false.")
    }
    
    // MARK: - Modified Issue
    
    // After the view is loaded, `isModifed` should be false
    // Expected result: isModifed = false
    func testIsModifedCase1() {
        XCTAssertFalse(sut.isModifed, "After the view is loaded, isModified variable should be false.")
    }
    
    // After modifying the project, `isModified` should be true
    func testIsModifedCase2() {
        sut.didSelectdProject(project: nil)
        XCTAssertTrue(sut.isModifed, "After modifying the project, isModifed variable should be true.")
    }
    
    // After modifying the issue type, `isModifed` should be true
    func testIsModifiedCase3() {
        sut.didSelectIssueType(issueType: nil)
        XCTAssertTrue(sut.isModifed, "After modifying the issue type, isModifed variable should be true")
    }
    
    // After modifying the text view, `isModified` should be true
    func testIsModifiedCase4() {
        sut.textViewDidChange(UITextView())
        
        XCTAssertTrue(sut.isModifed, "After modifying the text view, isModified variable should be true")
    }
    
    // After modifying the priority, `isModifed` should be true
    func testIsModifiedCase5() {
        sut.didSelectPriority(priority: Priority())
        
        XCTAssertTrue(sut.isModifed, "After modifying the priority, isModified variable should be true")
    }
    
    // After adding the attachment, `isModified` should be true
    func testIsModifedCase6() {
        sut.didAddAttachment(attachment: Attachment())
        XCTAssertTrue(sut.isModifed, "After adding a new attachment, isModifed variable should be true")
    }
    
    // After deleting an attachment, `isModifed` should be true
    func testIsModifedCase7() {
        sut.didDeleteAttachment(attachment: Attachment(), at: IndexPath())
        XCTAssertTrue(sut.isModifed, "After deleting the attachment, isModified varaible should be true")
    }
    
    // After selecting a date, `isModified` should be true
    func testIsModifiedCase8() {
        // Press on show more fields button
        sut.showMoreButtonPress(sender: UIButton())
        
        // Create a index path for the due date
        let dueDateIndexPath = IndexPath(row: 2, section: 0)
        
        // Perform a row selection on the due date cell
        sut.tableView(sut.tableView, didSelectRowAt: dueDateIndexPath)
        
        // Get select date view controller
        let selecteDateViewController = UIApplication.getTopViewController() as! SelectDateViewController
        // Load the view if needed.
        selecteDateViewController.loadViewIfNeeded()
        
        // Get the done button
        let doneButton = selecteDateViewController.doneButton!
        // Perform done button's action
        selecteDateViewController.performSelector(onMainThread: doneButton.action!
            , with: doneButton, waitUntilDone: true)
        
        XCTAssertTrue(sut.isModifed, "After selecting a due date, isModifed should be true.")
        
    }
    
    // After selecting the start date, isModifed should be true
    func testIsModifedCase9() {
        // Press on show more fields button
        sut.showMoreButtonPress(sender: UIButton())
        
        // Create a index path for the start date
        let dueDateIndexPath = IndexPath(row: 3, section: 0)
        
        // Perform a row selection on the start date cell
        sut.tableView(sut.tableView, didSelectRowAt: dueDateIndexPath)
        
        // Get select date view controller
        let selecteDateViewController = UIApplication.getTopViewController() as! SelectDateViewController
        // Load the view if needed.
        selecteDateViewController.loadViewIfNeeded()
        
        // Get the done button
        let doneButton = selecteDateViewController.doneButton!
        // Perform done button's action
        selecteDateViewController.performSelector(onMainThread: doneButton.action!
            , with: doneButton, waitUntilDone: true)
        
        XCTAssertTrue(sut.isModifed, "After selecting a start date, isModifed should be true.")
    }
    
    // After selecting the end date, isModified should be true
    func testIsModifiedCase10() {
        // Press on show more fields button
        sut.showMoreButtonPress(sender: UIButton())
        
        // Create a index path for the end date
        let dueDateIndexPath = IndexPath(row: 4, section: 0)
        
        // Perform a row selection on the end date cell
        sut.tableView(sut.tableView, didSelectRowAt: dueDateIndexPath)
        
        // Get select date view controller
        let selecteDateViewController = UIApplication.getTopViewController() as! SelectDateViewController
        // Load the view if needed.
        selecteDateViewController.loadViewIfNeeded()
        
        // Get the done button
        let doneButton = selecteDateViewController.doneButton!
        // Perform done button's action
        selecteDateViewController.performSelector(onMainThread: doneButton.action!
            , with: doneButton, waitUntilDone: true)
        
        XCTAssertTrue(sut.isModifed, "After selecting a end date, isModifed should be true.")
    }

    // MARK: - View's default value
    
    // After the view is loaded, it must have the following things as initial values
    // Project is set to the presenting project
    // Priority is set to Medium
    // Issue type is set to standard type
    // Start date is set to the current date
    
    func testSetUpViewCase1() {
        let project = Project()
        project.name = "New Project"
        let type = IssueTypeController.shared.default()
        let priority = PriorityController.shared.default()
        let date = Date()
        
        sut.initView(with: project, issueType: type , priority: priority, startDate: date, delegate: nil)
        
        XCTAssertEqual(project, sut.project)
        XCTAssertEqual(sut.issue?.type, type)
        XCTAssertEqual(sut.issue?.priority, priority)
        XCTAssertEqual(sut.issue?.startDate, date)
    }
    
    // MARK: - Select Project
    
    func testSelectProjectCase1() {
        // Setup in-memory realm
        setUpRealm(name: "In-MemoryRealm")
        let realm = try! Realm()
        
        // Inject realm to ProjectController
        ProjectController.shared.realm = realm
        // Add one project to realm
        let project = Project()
        project.name = "New Project"
        try! realm.write {
            realm.add(project)
        }
        
        sut.selectProjectPressed(sender: UIButton())
        
        let searchProjectViewController = UIApplication.getTopViewController() as! SearchProjectViewController
        searchProjectViewController.loadViewIfNeeded()
        
        // Make sure that there is one project in the list view
        XCTAssertEqual(1, searchProjectViewController.projectList!.count)
        
        // Select project at the first index path
        let indexPath = IndexPath(row: 0, section: 0)
        searchProjectViewController.tableView(searchProjectViewController.tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(sut.project?.id, project.id, "The view controller's project should be equal the selected project.")
    }
    
    // MARK: - Select Issue Type
    
    func testSelectIssueTypeCase1() {
        // Init sut
        sut.initView(with: Issue(), and: nil)
        
        // Setup in-memory realm
        setUpRealm(name: "In-MemoryRealm")
        let realm = try! Realm()
        
        // Inject in-memory realm to IssueTypeController
        IssueTypeController.shared.realm = realm
        
        // Add one issue type to realm
        let issueType = IssueType()
        issueType.name = "Story"
        try! realm.write {
            realm.add(issueType)
        }
        
        // Open the SelectIssueTypeViewController
        sut.selectTypePressed(sender: UIButton())
        
        XCTAssertNotNil(sut.presentedViewController, "The presented view controller should not be nil.")
        XCTAssertTrue(UIApplication.getTopViewController() is SelectIssueTypeTableViewController, "The presented view controller is not SelectIssueTableViewController.")
        
        // Get SelectIssueTypeViewController
        if let issueTypeViewController = UIApplication.getTopViewController() as? SelectIssueTypeTableViewController {
            issueTypeViewController.loadViewIfNeeded()
            
            // Make sure that there is one issue type in the list view
            XCTAssertEqual(1, issueTypeViewController.issueTypeList!.count, "There should be one issue type in the list view.")
            
            // Select Issue Type at the first index path
            let indexPath = IndexPath(row: 0, section: 0)
            issueTypeViewController.tableView(issueTypeViewController.tableView, didSelectRowAt: indexPath)
            
            // The view controller's issue type should be equal to the selected issue type
            XCTAssertEqual(sut.issue?.type?.id ?? "", issueType.id, "The view controller's issue type should be equal to the selected issue type.")
        }
        else {
            XCTFail("The view controller should not be empty.")
        }
    }
    
    // MARK: - Select Priority
    
    
    
}
