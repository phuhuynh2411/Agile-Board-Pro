//
//  Project.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import RealmSwift

class Project: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var projectDescription = ""
    @objc dynamic var key = ""
    
    // A project has many boards
    let boards = List<Board>()
    // A project has many issues
    let issues = List<Issue>()
    
    // A project has many sprints
    let sprints = List<Sprint>()
    
    let statuses = List<Status>()
    
    let issueTypes = List<IssueType>()
    
    @objc dynamic var icon: ProjectIcon?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var selectedBoard: Board?
  
}
