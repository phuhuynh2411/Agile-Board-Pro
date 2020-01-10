//
//  Column.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import RealmSwift

class Column: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var status: Status?
    
    // A column belongs to either one or more boards
    var boardOwners = LinkingObjects(fromType: Board.self, property: "columns")
    // House keeping fields
    @objc dynamic var createdDate = Date()
    @objc dynamic var modifiedDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
