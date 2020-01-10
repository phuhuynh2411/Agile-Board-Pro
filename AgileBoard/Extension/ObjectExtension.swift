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
    
    func write(code: ()->Void, completion: ((_ error: Error?)->Void)? ) {
        let realm = AppDataController.shared.realm
        
        do{
            try realm?.write {
                code()
                // Auto update the modify date
                self.setValue(Date(), forKey: "modifiedDate")
            }
            completion?(nil)
            print("Update modified date: \(String(describing: self.value(forKey: "modifiedDate")))")
        }catch{
            print(error)
            completion?(error)
        }
    }
    
}
