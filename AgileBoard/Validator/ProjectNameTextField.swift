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
    
    /**
     Validate the project name. The text is not empty and its length must be
     less than or equal maxLength
     */
    func isValid(returnValue: Bool) throws -> String {
        do{
            try validate()
            return text!
        }catch{
            throw error
        }
    }
    
    func isValid() throws {
        do {
            try validate()
        }catch{
            throw error
        }
    }

    fileprivate func validate() throws {
        guard  text!.count <= maxLength && !text!.isEmpty
        else {
            throw ValidatorError(description: "Invalid project name.")
        }
    }

}
