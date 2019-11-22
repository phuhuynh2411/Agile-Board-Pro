//
//  Story.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import RealmSwift

class Issue: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var summary = ""
    @objc dynamic var assignee: String?
    
    // A issue belongs to either one or more projects
    let projectOwners = LinkingObjects(fromType: Project.self, property: "issues")
    
    // A issue only has one status
    @objc dynamic var status: Status?
}
