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
        return .priority(name: "Highest", imageName: "priority_highest")
    }
    
    static var high: Priority {
        return .priority(name: "High", imageName: "priority_high")
    }
    
    static var medium: Priority {
        return .priority(name: "Medium", imageName: "priority_medium")
    }
    
    static var low: Priority {
        return .priority(name: "Low", imageName: "priority_low")
    }
    
    static var lowest: Priority {
        return .priority(name: "Lowest", imageName: "priority_lowest")
    }
    
    static func findPriority(by name: String)->Priority? {
        
        if let type = shared.realm?.objects(Priority.self).filter({ (priority) -> Bool in
            priority.name.lowercased() == name.lowercased()
        }).first {
            return type
        }else {
            return nil
        }
    }
    
    static func priority(name: String, imageName: String) -> Priority {
        if let priority = findPriority(by: name) { return priority }
        
        let priority = Priority()
        priority.name = name
        priority.imageName = imageName
        
        return priority
    }
    
}
