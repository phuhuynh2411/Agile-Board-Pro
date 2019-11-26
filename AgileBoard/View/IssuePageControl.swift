//
//  IssuePageControl.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/26/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssuePageControl: UIPageControl {

    var heightConstrait: NSLayoutConstraint {
        return self.constraints.first { $0.identifier == "heightConstrant" }!
    }
    
    func setVisible(state: Bool, with height: CGFloat) {
        
        // Show the page control and just the height constrait to
        // a value which is greater than zero
        if state {
            self.isHidden = false
            
        }
        else {
            self.isHidden = true
        }
        
        // Adjust the constrant
        heightConstrait.constant = height
            
        // Update the layout
        layoutIfNeeded()
        
    }

}
