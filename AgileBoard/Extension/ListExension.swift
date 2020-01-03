//
//  ListExension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

extension List {
    
    func insert(_ element: Element, at index: Int, completion: ((_ error: Error?)->Void)?) {
        let realm = AppDataController.shared.realm
        do{
            try realm?.write {
                self.insert(element, at: index)
            }
            completion?(nil)
        }catch{
            print(error)
            completion?(error)
        }
    }
    
    func append(_ element: Element,completion: ((_ error: Error?)->Void)?) {
        let realm = AppDataController.shared.realm
        do{
            try realm?.write {
                self.append(element)
            }
            completion?(nil)
        }catch{
            print(error)
            completion?(error)
        }
    }
    
    func remove(at index: Int,completion: ((_ error: Error?)->Void)?) {
        let realm = AppDataController.shared.realm
        do{
            try realm?.write {
                self.remove(at: index)
            }
            completion?(nil)
        }catch{
            print(error)
            completion?(error)
        }
    }
    
    func write(code:()->Void, completion: ((_ error: Error?)->Void)?){
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
