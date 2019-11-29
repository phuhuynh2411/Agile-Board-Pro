//
//  StatusController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/28/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class StatusController {
    static let realm = try! Realm()
    
    static func status(name: String) -> Status {
        
        if let status = realm.objects(Status.self).filter({ (status) -> Bool in
            status.name.lowercased() == name.lowercased()
        }).first {
            return status
        }
        else {
            let status = Status()
            status.name = name
            return status
        }
        
    }
    
}
