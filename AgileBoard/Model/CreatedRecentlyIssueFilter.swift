//
//  CreatedRecentlyIssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/15/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class CreatedRecentlyIssueFilter: IssueFilter{
    
    override var issues: Results<Issue>? {
        let calendar = Calendar.current
        
        // Created recently issues
        // are created today
        // and sorted by descending.
        let dateFrom = calendar.dateFrom
        let dateTo = calendar.dateTo
        
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self).filter("createdDate >= %@ AND createdDate <= %@ ", dateFrom, dateTo)
        
        // Need to sort the issue by due date
        return issues?.sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    func sectionFor(_ issue: Issue) -> String {
        return ""
    }
}
