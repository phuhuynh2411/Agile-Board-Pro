//
//  Sprint.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/27/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class Sprint: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    
    // A print can has multiple issue
    let issues = List<Issue>()
    
    // House keeping fields
    @objc dynamic var createdDate = Date()
    @objc dynamic var modifiedDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
