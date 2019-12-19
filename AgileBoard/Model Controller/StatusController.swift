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
    
    var realm: Realm?
    
    static var shared = StatusController()
    
    init() {
        do{
            realm = try Realm()
        } catch{
            print(error)
        }
    }
    
    func status(name: String) -> Status {
        
        if let status = realm?.objects(Status.self).filter({ (status) -> Bool in
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
    
    func update(status: Status, toStatus: Status) {
        do{
            try realm?.write {
                status.color = toStatus.color
                status.name = toStatus.name
            }
        }catch{
            print(error)
        }
    }
}
