//
//  IssueType.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/28/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class IssueType: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var imageName = ""
    @objc dynamic var typeDescription = ""
    @objc dynamic var standard = false
    // House keeping fields
    @objc dynamic var createdDate = Date()
    @objc dynamic var modifiedDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
