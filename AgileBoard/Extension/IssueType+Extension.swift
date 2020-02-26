//
//  IssueType+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

extension IssueType {
        
    static var standard: IssueType{
        return story
    }
    
    static var story: IssueType {
        
        if let type = typeByName(name: "Story") { return type }
        
        let issueType = IssueType()
        issueType.name = "Story"
        issueType.imageName = "issue_story"
        issueType.standard = true
        issueType.typeDescription = "A short, simple descriptions of a feature."
        
        return issueType
    }
    
    static var epic: IssueType {
        if let type = typeByName(name: "Epic") { return type }

        let issueType = IssueType()
        issueType.name = "Epic"
        issueType.imageName = "issue_epic"
        issueType.typeDescription = "It's essentically a large user story that can be broken down into a number of smaller stories."
        
        return issueType
    }
    
    static var task: IssueType {
        if let type = typeByName(name: "Task") { return type }

        let issueType = IssueType()
        issueType.name = "Task"
        issueType.imageName = "issue_task"
        issueType.typeDescription = "A work that needs to be done."
        
        return issueType
    }
    
    static var bug: IssueType {
        if let type = typeByName(name: "Bug") { return type }

        let issueType = IssueType()
        issueType.name = "Bug"
        issueType.imageName = "issue_bug"
        issueType.typeDescription = "A problem that prevents the functions of a product."
        
        return issueType
    }
    
    static func typeByName(name: String)->IssueType? {
        let realm = AppDataController.shared.realm
        
        if let type = realm?.objects(IssueType.self).filter({ (type) -> Bool in
            type.name.lowercased() == name
        }).first {
            return type
        }else {
            return nil
        }
    }
    
}
