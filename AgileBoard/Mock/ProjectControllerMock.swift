//
//  ProjectControllerMock.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
class ProjectControllerMock: ProjectController {
    
    override func add(project: Project, _ callback: (NSError?) -> Void) {
        let error = NSError(domain: "", code: 0, userInfo: ["errorMessage" : "Failed adding project to realm."])
        callback(error)
    }
    
    override func update(project: Project, by anotherProject: Project, _ callback: (NSError?) -> Void) {
        let error = NSError(domain: "", code: 0, userInfo: ["errorMessage" : "Failed updating project to realm."])
             callback(error)
    }
}
