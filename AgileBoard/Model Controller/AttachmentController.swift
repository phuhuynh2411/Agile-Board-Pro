//
//  AttachmentController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/5/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class AttachmentController {
    var realm: Realm?
    
    init() {
        do{
            self.realm  = try Realm()
        }catch let error as NSError {
            print(error)
        }
    }
    
    static var shared = AttachmentController()
    
    func createSampleAttachments(){
        
    }
    
}
