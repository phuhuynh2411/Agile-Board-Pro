//
//  ProjectKeyRule.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 3/7/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import SwiftValidator

class ProjectKeyRule: Rule {
    
    var project: Project?
    let realm = AppDataController.shared.realm
    
    init(project: Project?) {
        self.project = project
    }
    
    func validate(_ value: String) -> Bool {
        let firstFoundProject = realm!.objects(Project.self).filter { projectInRealm in
            projectInRealm.key.lowercased() == value.lowercased()
        }.first
        
        return firstFoundProject == nil ? true : firstFoundProject == self.project
    }
    
    func errorMessage() -> String {
        return "This field must be unique."
    }
}
