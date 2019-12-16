//
//  PriorityController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class PriorityController {
    
    private var realm: Realm?
    
    init() {
        do{
            self.realm  = try Realm()
        }catch let error as NSError {
            print(error)
        }
    }
    
    static var shared = PriorityController()
    
    func createSamplePriorities() {
        
        let priority1 = Priority()
        priority1.name = "Highest"
        priority1.imageName = "priority_highest"
        add(priority1)
        
        let priority2 = Priority()
        priority2.name = "High"
        priority2.imageName = "priority_high"
        add(priority2)
        
        let priority3 = Priority()
        priority3.name = "Medium"
        priority3.imageName = "priority_medium"
        priority3.standard = true
        add(priority3)
        
        let priority4 = Priority()
        priority4.name = "Low"
        priority4.imageName = "priority_low"
        add(priority4)
        
        let priority5 = Priority()
        priority5.name = "Lowest"
        priority5.imageName = "priority_lowest"
        add(priority5)
        
    }
    
    func add(_ priority: Priority) {
        do{
            try realm?.write {
                realm?.add(priority)
            }
        }catch let error as NSError {
            print(error)
        }
    }
    
    func all() -> Results<Priority>? {
        return realm?.objects(Priority.self)
    }
    
    func `default`() -> Priority?{
        return realm?.objects(Priority.self).filter({ (priority) -> Bool in
            priority.standard == true
            }).first
    }
    
}
