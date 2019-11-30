//
//  ValidatorError.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation

struct ValidatorError: Error{
    var description: String
    
    init(description: String) {
        self.description = description
    }
}
