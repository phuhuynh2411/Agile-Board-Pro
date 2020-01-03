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
        
    }
}
