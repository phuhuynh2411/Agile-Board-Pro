//
//  Column.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import RealmSwift

class Status: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    
    @objc dynamic var color: Color?
    // House keeping fields
    @objc dynamic var createdDate = Date()
    @objc dynamic var modifiedDate = Date()
    @objc dynamic var markedAsDone = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
