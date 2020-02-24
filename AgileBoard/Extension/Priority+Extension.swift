//
//  Priority+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Priority {
    
    static let shared = Priority()
    
    static var standard: Priority {
        return medium
    }
    
    static var highest: Priority {
        if let prioriy = priorityByName(name: "Highest") { return prioriy }
        
        let priority = Priority()
        priority.name = "Highest"
        priority.imageName = "priority_highest"
        return priority
    }
    
    static var high: Priority {
        if let prioriy = priorityByName(name: "High") { return prioriy }
        
        let priority = Priority()
        priority.name = "High"
        priority.imageName = "priority_high"
        return priority
    }
    
    static var medium: Priority {
        if let priority = priorityByName(name: "Medium") { return priority }
        
        let priority = Priority()
        priority.name = "Medium"
        priority.imageName = "priority_medium"
        priority.standard = true
        
        return priority
    }
    
    static var low: Priority {
        if let priority = priorityByName(name: "Low") { return priority }
        
        let priority = Priority()
        priority.name = "Low"
        priority.imageName = "priority_low"
        
        return priority
    }
    
    static var lowest: Priority {
        if let priority = priorityByName(name: "Lowest") { return priority }
        
        let priority = Priority()
        priority.name = "Lowest"
        priority.imageName = "priority_lowest"
        
        return priority
    }
    
    static func priorityByName(name: String)->Priority? {
        
        if let type = shared.realm?.objects(Priority.self).filter({ (priority) -> Bool in
            priority.standard == true
        }).first {
            return type
        }else {
            return nil
        }
    }
    
}
