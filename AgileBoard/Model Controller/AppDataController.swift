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
    
    static let realm = try! Realm()
    
    static func createSampleData() {
        
        // Clear previous data
        try! realm.write {
            realm.deleteAll()
        }
        
        // Create Sample Issue Types
        IssueTypeController.createSampleIssueTypes()
        // Create sample Project Icons
        ProjectIconController.createSampleIcons()
        // Create sample Projects
        ProjectController.createSampleProjects()
    }
}
