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
    lazy var realm = try! Realm()
    
    func status(name: String) -> Status {
        
        if let status = realm.objects(Status.self).filter({ (status) -> Bool in
            status.name.lowercased() == name.lowercased()
        }).first {
            print("Reuse status")
            return status
        }
        else {
            let status = Status()
            status.name = name
            return status
        }
        
    }
    
}
