//
//  ProjectIcon.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class ProjectIcon: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    
}
