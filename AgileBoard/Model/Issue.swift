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
    @objc dynamic var orderNumber: Int = 0
    @objc dynamic var issueDescription = ""
    @objc dynamic var serial: Int = 0
    
    // A issue belongs to either one or more projects
    let projectOwners = LinkingObjects(fromType: Project.self, property: "issues")
    
    // A issue only has one status
    @objc dynamic var status: Status?
    
    // A issue only has one issue type
    @objc dynamic var type: IssueType?
    
    // Issue's priority
    @objc dynamic var priority: Priority?
    
    // An issue has many attachments
    let attachments = List<Attachment>()
    
    // Due date
    @objc dynamic var dueDate: Date?
    @objc dynamic var startDate: Date?
    @objc dynamic var endDate: Date?
    
    var issueID: String {
        return "\(projectOwners.first?.key ?? "")-\(serial)"
    }
    
    static func incrementID() -> Int {
        
        let realm = try! Realm()
        
        var nextNumber = realm.objects(Issue.self).max(ofProperty: "orderNumber") as Int? ?? 0
        nextNumber = nextNumber == 0 ? 0 : nextNumber + 1
        
        return nextNumber
        
    }
    
}
