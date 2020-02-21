//
//  DueThisWeekIssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class DueThisWeekIssueFilter: IssueFilter {
    
    override var type: BaseIssueFilter.IssueFilterType? {
              return .dueThisWeek
    }
    
    override var issues: Results<Issue>? {
        let calendar = Calendar.current
        
        // Due this week issues
        // has Due date is greater than or equal the current date
        // and its status is not marked as Done.
        
        // Make sure we can get the start and end of the current week
        guard let weekStartDate = calendar.startOfWeek, let endWeekDate = calendar.endOfWeek else {
            fatalError("The start and end date of the week is not available.")
        }
        print("Start date of the week: \(weekStartDate)")
        print("End date of the week: \(endWeekDate)")
        
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self).filter("dueDate >= %@ AND dueDate <= %@ AND status.markedAsDone = %@", weekStartDate, endWeekDate, false)
        
        // Need to sort the issue by due date
        return issues?.sorted(byKeyPath: "dueDate", ascending: true)
    }
    
    func sectionFor(_ issue: Issue) -> String {
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .none
        var sectionKey = ""
        
        guard let dueDate = issue.dueDate else {
            fatalError("An error occured with issues property. The due date should not be empty.")
        }
        let calendar = Calendar.current
        if calendar.isDateInToday(dueDate) {
            sectionKey = "Today"
        } else if calendar.isDateInTomorrow(dueDate) {
            sectionKey = "Tomorrow"
        } else if calendar.isDateInThisWeek(dueDate) {
            sectionKey = "This week"
        }
        
        return sectionKey
    }
    
}
