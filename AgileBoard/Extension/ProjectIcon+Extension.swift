//
//  ProjectIcon+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension ProjectIcon {
    
    static var standard: ProjectIcon {
           return .icon(name: "project_CFI")
    }
        
    static var alarm: ProjectIcon {
        return .icon(name: "project_alarm")
    }
    
    static var cammera: ProjectIcon {
        return .icon(name: "project_cammera")
    }
    
    static var email: ProjectIcon {
        return .icon(name: "project_email")
    }
    
    static var heart: ProjectIcon {
        return .icon(name: "project_heart")
    }
    
    static var lock: ProjectIcon {
        return .icon(name: "project_lock")
    }
    
    static var photo: ProjectIcon {
        return .icon(name: "project_photo")
    }
    
    static var photo2: ProjectIcon {
        return .icon(name: "project_photo2")
    }
    
    static var shield: ProjectIcon {
        return .icon(name: "project_shield")
    }
    
    static var tidy: ProjectIcon {
        return .icon(name: "project_tidy")
    }
    
    static var cloud: ProjectIcon {
        return .icon(name: "project_cloud")
    }
    
    static func findIcon(by name: String)->ProjectIcon? {
        let realm = AppDataController.shared.realm
        
        if let icon = realm?.objects(ProjectIcon.self).filter({ (icon) -> Bool in
            icon.name.lowercased() == name.lowercased()
        }).first {
            return icon
        }else {
            return nil
        }
    }
    
    static func icon(name: String)-> ProjectIcon {
        if let icon = findIcon(by: name) { return icon }
        
        let icon = ProjectIcon()
        icon.name = name
        return icon
    }
    
}
