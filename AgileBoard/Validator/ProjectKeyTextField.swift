//
//  ProjectKeyTextField.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ProjectKeyTextField: UITextField {
    let maxLength = 5

    func isValid() throws -> String {
        if text!.count <= maxLength && !text!.isEmpty {
            return text!
        }
        else {
            throw ValidatorError(description: "Invalid project key.")
        }
    }
}
