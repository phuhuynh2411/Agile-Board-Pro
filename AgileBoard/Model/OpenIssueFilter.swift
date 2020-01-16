//
//  OpenIssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/15/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class OpenIssueFilter: AllIssueFilter{
    
    override var type: BaseIssueFilter.IssueFilterType? {
        return .open
    }
    
    override var issues: Results<Issue>? {
        // Open issues
        // are issues that have status not Done
        
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self).filter("status.markedAsDone = %@ ", false)
        
        // Need to sort the issue by created date
        return issues?.sorted(byKeyPath: "createdDate", ascending: false)
    }
    
}
