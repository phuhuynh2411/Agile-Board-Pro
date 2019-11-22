//
//  Project.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation

class Project {
    
    let id: UUID
    let name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init(name: String) {
        self.init(id: UUID(), name: name)
    }
    
}
