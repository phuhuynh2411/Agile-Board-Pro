//
//  Priority.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class Priority: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var imageName = ""
    @objc dynamic var standard = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
