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
            }
            completion?(nil)
        }catch{
            print(error)
            completion?(error)
        }
    }
    
}
