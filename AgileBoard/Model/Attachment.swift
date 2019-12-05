//
//  Attachment.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/5/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class Attachment: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var url = ""
    
}
