//
//  IssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class IssueFilter: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var predicate = ""
    // House keeping fields
    @objc dynamic var createdDate = Date()
    @objc dynamic var modifiedDate = Date()
    
    let sections = List<FilterSection>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
