//
//  Board.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import RealmSwift

class Board: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    
    // A board belongs to either one or more projects
    let projectOwners = LinkingObjects(fromType: Project.self, property: "boards")
    
    // A board has many columns
    var columns = List<Column>()
    
    // House keeping fields
    @objc dynamic var createdDate = Date()
    @objc dynamic var modifiedDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
