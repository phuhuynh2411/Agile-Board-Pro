//
//  AppDataController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class AppDataController {
    
    var realm: Realm?
    
    init() {
        do{
            self.realm  = try Realm()
        }catch let error as NSError {
            print(error)
        }
    }
    
    static var shared = AppDataController()
        
    func createSampleData() {
        
        // Clear previous data
        do{
            try realm?.write {
                realm?.deleteAll()
            }
        }catch{
            print(error)
        }
        
        // Create Sample Issue Types
        IssueTypeController.shared.createSampleIssueTypes()
        // Create sample Project Icons
        ProjectIconController.createSampleIcons()
        // Create sample priorities
        PriorityController.shared.createSamplePriorities()
        // Create sample colors
        ColorController.shared.createSampleColors()
        // Create sample Projects
        let projectController = ProjectController()
        projectController.createSampleProjects()
        
        // All filter
        let allFilter = IssueFilter()
        allFilter.name = "All"
        let todaySection = FilterSection()
        todaySection.name = "Today"
        todaySection.prediate = "createdDate = %@"
        let yesterdaySection = FilterSection()
        yesterdaySection.name = "Yesterday"
        yesterdaySection.prediate = "createdDate = %@"
        let thisWeekSection = FilterSection()
        thisWeekSection.name = "This Week"
        thisWeekSection.prediate = "createdDate = %@"
        let lastWeekSection = FilterSection()
        lastWeekSection.name = "Last Week"
        lastWeekSection.prediate = "createdDate = %@"
        
        allFilter.sections.append(objectsIn: [todaySection, yesterdaySection, thisWeekSection, lastWeekSection])
        
        
        // Create issue filters
        do{
            try realm?.write {
                //All
                //realm?.add(IssueFilter(value: ["name":  "All", "predicate": ""]))
                realm?.add(allFilter)
                //Due today
                realm?.add(IssueFilter(value: ["name":  "Due today", "predicate": "dueDate = %@"]))
                //Due this week
                realm?.add(IssueFilter(value: ["name":  "Due this week", "predicate": "dueDate = %@"]))
                //Created recently
                realm?.add(IssueFilter(value: ["name":  "Created recently", "predicate": "createdDate = %@"]))
                //Updated recently
                realm?.add(IssueFilter(value: ["name":  "Updated recently", "predicate": "modifiedDate = %@"]))
                //Open
                realm?.add(IssueFilter(value: ["name":  "Open", "predicate": "status.id = %@"]))
                //Done
                realm?.add(IssueFilter(value: ["name":  "Done", "predicate": "status.id = %@"]))
            }
        }catch {
            print(error)
        }
        
        
        
    }
}
