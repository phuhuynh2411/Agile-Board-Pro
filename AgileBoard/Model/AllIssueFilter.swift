//
//  AllIssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class AllIssueFilter: IssueFilter {
    
    override var issues: Results<Issue>? {
        // Load all issues
        let realm = AppDataController.shared.realm
        let issues = realm?.objects(Issue.self)
        
        // Sort issue by date
        return issues?.sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    func sectionFor(_ issue: Issue)->String {
        
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .none
        var sectionKey = ""
        
        let calendar = Calendar.current
        if calendar.isDateInToday(issue.createdDate) {
            sectionKey = "Today"
        } else if calendar.isDateInYesterday(issue.createdDate) {
            sectionKey = "Yesterday"
        } else if calendar.isDateInThisWeek(issue.createdDate) {
            sectionKey = "This week"
        } else if calendar.isDateInLastWeek(issue.createdDate) {
            sectionKey = "Last Week"
        } else if calendar.isDateInThisMonth(issue.createdDate) {
            sectionKey = "This Month"
        } else if calendar.isDateInLastMonth(issue.createdDate) {
            sectionKey = "Last Month"
        } else {
            dateFormater.dateFormat = "MMMM yyyy"
            sectionKey = dateFormater.string(from: issue.createdDate)
        }
        return sectionKey
    }
    
}
