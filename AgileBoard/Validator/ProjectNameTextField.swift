//
//  ProjectNameTextField.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ProjectNameTextField: UITextField {
    
    /// Maximum characters of the project name
    let maxLength = 80

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
     Validate the project name. The text is not empty and its length must be
     less than or equal maxLength
     */
    func isValid() throws -> Bool{
        if text!.count >= maxLength && !text!.isEmpty {
            return true
        }
        else {
            throw ValidatorError(message: "Invalid project name.")
        }
    }

}
