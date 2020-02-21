//
//  DueTodayIssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class DueTodayIssueFilter: IssueFilter {
    
    override var type: BaseIssueFilter.IssueFilterType? {
           return .dueToday
    }
    
    override var issues: Results<Issue>? {
        let calendar = Calendar.current
        
        //Get today's beginning & end
        let dateFrom = calendar.dateFrom
        let dateTo = calendar.dateTo
        
        // Load all issues that have due date is equal today
        // and its status is marked as completed.
        
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self).filter("dueDate >= %@ AND dueDate <= %@ AND status.markedAsDone = %@", dateFrom, dateTo, false)
        
        return issues
    }
    
    func sectionFor(_ issue: Issue)->String {
        return ""
    }
    
}

