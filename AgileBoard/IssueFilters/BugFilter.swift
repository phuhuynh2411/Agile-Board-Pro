//
//  BugFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/27/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class BugFilter: AllIssueFilter {
    
    override var type: BaseIssueFilter.IssueFilterType? {
           return .bug
    }
    
    override var issues: Results<Issue>? {
        
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self).filter("type = %@ ", IssueType.bug)
        
        // Need to sort the issue by created date
        return issues?.sorted(byKeyPath: "createdDate", ascending: true)
    }
}
