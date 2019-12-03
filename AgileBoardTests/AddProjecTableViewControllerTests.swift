//
//  AgileBoardTests.swift
//  AgileBoardTests
//
//  Created by Huynh Tan Phu on 12/2/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import XCTest

@testable import AgileBoard
import RealmSwift

class AddProjecTableViewControllerTests: XCTestCase {
    
    var sut: AddProjectTableViewController!
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyBoard.instantiateViewController(withIdentifier: "addProjectTableViewController") as? AddProjectTableViewController
        sut.loadView()
        sut.viewDidLoad()
    
    }
    
    func setUpRealm(name: String) {
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Invalid keys
    
    /// Key is more than 5 characters
    func testInvalidProjectKey1() {
        sut.keyTextField.text = "INVALID KEY"
        sut.validator.validate(sut)
        
        XCTAssertFalse(sut.validated, "The project key is invalid.")
    }
    
    /// Key is empty
    func testInvalidProjectKey2() {
        sut.keyTextField.text = ""
        sut.validator.validate(sut)
        
        XCTAssertFalse(sut.validated, "The project key is empty")
    }
    
    // MARK: - Valid key
    
    /// Key is valid with 1 character
    func testVaidKey1() {
        sut.nameTextField.text = "Valid Project Name"
        sut.keyTextField.text = "A"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 2 characters
    func testValidKey2() {
        sut.nameTextField.text = "Valid Project Name"
        sut.keyTextField.text = "JB"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 3 characters
    func testValidKey3() {
        sut.nameTextField.text = "Valid Project Name"
        sut.keyTextField.text = "BNH"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 4 characters
    func testValidKey4() {
        sut.nameTextField.text = "Valid Project Name"
        sut.keyTextField.text = "BNHD"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 5 characters
    func testValidKey5() {
        sut.nameTextField.text = "Valid Project Name"
        sut.keyTextField.text = "BNHDD"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    // MARK: - Invalid project name
    
    /// Empty project name
    func testInvalidName1() {
        sut.nameTextField.text = ""
        sut.validator.validate(sut)
        XCTAssertFalse(sut.validated)
    }
    
    /// More than 30 characters
    func testInvalidName2() {
        sut.nameTextField.text = "I am entering the project name which has more than 30 characters."
        sut.validator.validate(sut)
        XCTAssertFalse(sut.validated)
    }
    
    // MARK: - Valid project name
    
    func testValidName1() {
        sut.keyTextField.text = "CRM"
        sut.nameTextField.text = "New project: CRM"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    // MARK: - Add Project
    
    func testAddProject() {
        setUpRealm(name: "addProjectRealm")
        
        sut.nameTextField.text = "New Project"
        sut.keyTextField.text = "NP"
        sut.descriptionTextView.text = "This is a short description for the project."
        // make sure it passes the validation step
        sut.validated = true
        
        sut.doneButtonPressed(UIBarButtonItem())
        
        let realm = try! Realm()
        
        let project = realm.objects(Project.self).first!
        
        XCTAssertEqual(sut.project!.id , project.id, "The project was not properly created.")
        
    }
    
    // MARK: -  Modify project
    
    func testModifyProjectName() {
        setUpRealm(name: "modifyProjectRealm")
        let realm = try! Realm()
        
        let project = Project()
        project.name = "Valid Project Name"
        project.projectDescription = "Short description of the project"
        project.key = "ABC"
        // Add to realm
        try! realm.write {
            realm.add(project)
        }
        // Add project to the view controller
        sut.project = project
        sut.viewDidLoad()
        
        // make sure it passes the validation step
        sut.validated = true
        sut.nameTextField.text = "I modified the project name"
        
        sut.doneButtonPressed(UIBarButtonItem())
        
        let editedProject = realm.objects(Project.self).first!
        
        XCTAssertEqual(sut.project!.name , editedProject.name, "The project name was not properly modified.")
    }
    
    func testModifyProjectKey() {
        setUpRealm(name: "modifyProjectRealm")
        let realm = try! Realm()
        
        let project = Project()
        project.name = "Valid Project Name"
        project.projectDescription = "Short description of the project"
        project.key = "ABC"
        // Add to realm
        try! realm.write {
            realm.add(project)
        }
        // Add project to the view controller
        sut.project = project
        sut.viewDidLoad()
        
        // make sure it passes the validation step
        sut.keyTextField.text = "NewKEY"
        sut.validated = true
        
        sut.doneButtonPressed(UIBarButtonItem())
        
        let editedProject = realm.objects(Project.self).first!
        
        XCTAssertEqual(sut.project!.key , editedProject.key, "The project key was not properly modified.")
    }

    func testModifyProjectDescription() {
           setUpRealm(name: "modifyProjectRealm")
           let realm = try! Realm()
           
           let project = Project()
           project.name = "Valid Project Name"
           project.projectDescription = "Short description of the project"
           project.key = "ABC"
           // Add to realm
           try! realm.write {
               realm.add(project)
           }
           // Add project to the view controller
           sut.project = project
           sut.viewDidLoad()
           
           // make sure it passes the validation step
        sut.descriptionTextView.text = "I modified the project description"
           sut.validated = true
           
           sut.doneButtonPressed(UIBarButtonItem())
           
           let editedProject = realm.objects(Project.self).first!
           
           XCTAssertEqual(sut.project!.projectDescription , editedProject.projectDescription, "The project description was not properly modified.")
       }
}
