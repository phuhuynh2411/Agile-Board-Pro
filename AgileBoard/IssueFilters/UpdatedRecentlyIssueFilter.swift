//
//  UpdateRecentlyIssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/15/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class UpdatedRecentlyIssueFilter: IssueFilter{
    
    override var type: BaseIssueFilter.IssueFilterType? {
        return .updateRecently
    }
    
    override var issues: Results<Issue>? {
        let calendar = Calendar.current
        
        // Created recently issues
        // are modifiedDate today
        // and sorted by descending.
        let dateFrom = calendar.dateFrom
        let dateTo = calendar.dateTo
        
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self).filter("modifiedDate >= %@ AND modifiedDate <= %@ ", dateFrom, dateTo)
        
        // Need to sort the issue by due date
        return issues?.sorted(byKeyPath: "modifiedDate", ascending: false)
    }
    
    func sectionFor(_ issue: Issue) -> String {
        return ""
    }
}
