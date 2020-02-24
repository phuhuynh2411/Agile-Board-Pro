//
//  IssueTypeController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/28/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class IssueTypeController {
    
    var realm: Realm?
    
    init() {
        do{
            self.realm  = try Realm()
        }catch let error as NSError {
            print(error)
        }
    }
    
    static var shared = IssueTypeController()
    
    func createSampleIssueTypes() {
        
        let issueType1 = IssueType()
        issueType1.name = "Story"
        issueType1.imageName = "issue_story"
        issueType1.standard = true
        issueType1.typeDescription = "A short, simple descriptions of a feature."
        
        let issueType2 = IssueType()
        issueType2.name = "Epic"
        issueType2.imageName = "issue_epic"
        issueType2.typeDescription = "It's essentically a large user story that can be broken down into a number of smaller stories."
        
        let issueType3 = IssueType()
        issueType3.name = "Task"
        issueType3.imageName = "issue_task"
        issueType3.typeDescription = "A work that needs to be done."
        
        let issueType4 = IssueType()
        issueType4.name = "Bug"
        issueType4.imageName = "issue_bug"
        issueType4.typeDescription = "A problem that prevents the functions of a product."
        
        do {
            try realm?.write {
                realm?.add(issueType1)
                realm?.add(issueType2)
                realm?.add(issueType3)
                realm?.add(issueType4)
            }
        }
        catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func all()-> Results<IssueType>? {
        return realm?.objects(IssueType.self)
    }
    
    func `default`() -> IssueType?{
        return realm?.objects(IssueType.self).filter({ (type) -> Bool in
            type.standard == true
        }).first
    }
    
    func story() ->IssueType {
        let issueType = IssueType()
        issueType.name = "Story"
        issueType.imageName = "issue_story"
        issueType.standard = true
        issueType.typeDescription = "A short, simple descriptions of a feature."
        
        return issueType
    }
    
    func epic()->IssueType {
        let issueType = IssueType()
        issueType.name = "Epic"
        issueType.imageName = "issue_epic"
        issueType.typeDescription = "It's essentically a large user story that can be broken down into a number of smaller stories."
        
        return issueType
    }
    
    func task()->IssueType {
        let issueType = IssueType()
        issueType.name = "Task"
        issueType.imageName = "issue_task"
        issueType.typeDescription = "A work that needs to be done."
        
        return issueType
    }
    
    func bug()->IssueType {
        let issueType = IssueType()
        issueType.name = "Bug"
        issueType.imageName = "issue_bug"
        issueType.typeDescription = "A problem that prevents the functions of a product."
        
        return issueType
    }
    
    
}
