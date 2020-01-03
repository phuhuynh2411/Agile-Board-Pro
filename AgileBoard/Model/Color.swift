//
//  Color.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class Color: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var hexColor = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
