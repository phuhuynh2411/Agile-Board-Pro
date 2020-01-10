//
//  FilterSection.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class FilterSection: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var prediate = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
