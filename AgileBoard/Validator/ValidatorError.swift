//
//  ValidatorError.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation

struct ValidatorError: Error{
    var message: String
    
    init(message: String) {
        self.message = message
    }
}
