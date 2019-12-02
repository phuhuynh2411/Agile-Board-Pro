//
//  AgileBoardTests.swift
//  AgileBoardTests
//
//  Created by Huynh Tan Phu on 12/2/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import XCTest

@testable import AgileBoard

class AddProjecTableViewControllerTests: XCTestCase {
    
    var sut: AddProjectTableViewController!
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyBoard.instantiateViewController(withIdentifier: "addProjectTableViewController") as? AddProjectTableViewController
        sut.loadView()
        sut.viewDidLoad()
    
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
        sut.keyTextField.text = "A"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 2 characters
    func testValidKey2() {
        sut.keyTextField.text = "JB"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 3 characters
    func testValidKey3() {
        sut.keyTextField.text = "BNH"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 4 characters
    func testValidKey4() {
        sut.keyTextField.text = "BNHD"
        sut.validator.validate(sut)
        XCTAssert(sut.validated)
    }
    
    /// Key is valid with 5 characters
    func testValidKey5() {
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
        sut.nameTextField.text = "jdshfjdfshfjsdjfhsdjfsjdbfjsjfweiruwieksdnfksjdkfsfsf"
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

}
