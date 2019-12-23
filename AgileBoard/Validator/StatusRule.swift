//
//  StatusRule.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/23/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import SwiftValidator

class StatusRule: Rule {
    var project: Project
    
    init(project: Project) {
        self.project = project
    }
    /**
     If project already contains the project name, the validation will be failed; otherwise true.
     */
    func validate(_ value: String) -> Bool {
        return !project.statuses.contains { (status) -> Bool in
            status.name == value
        }
    }
    
    func errorMessage() -> String {
        return "This field must be unique."
    }
}
