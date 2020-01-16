//
//  DoneIssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/15/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class DoneIssueFilter: AllIssueFilter{
    
    override var type: BaseIssueFilter.IssueFilterType? {
        return .done
    }
    
    override var issues: Results<Issue>? {
        // Done issues
        // are issues that have status Done
        
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self).filter("status.markedAsDone = %@ ", true)
        
        // Need to sort the issue by created date
        return issues?.sorted(byKeyPath: "createdDate", ascending: true)
    }
    
}
