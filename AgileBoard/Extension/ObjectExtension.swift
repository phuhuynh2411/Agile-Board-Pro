//
//  ObjectExtension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    /**
     Write to Realm and update modified date
     */
    func write(_ code: ()->Void, completion: ((_ error: Error?)->Void)? ) {
        do{
            try realm?.write {
                code()
                // Auto update the modify date
                self.setValue(Date(), forKey: "modifiedDate")
            }
            completion?(nil)
        }catch{
            print(error)
            completion?(error)
        }
    }
    
    /**
    Write to Realm and update modified date
    */
    func write(_ code: ()->Void) throws {
        try realm?.write {
            code()
            self.setValue(Date(), forKey: "modifiedDate")
        }
    }
    
    /**
     Remove an object its self
     */
    
    @objc func remove() throws {
        try realm?.write {
            realm?.delete(self)
        }
    }
    
}
