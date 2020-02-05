//
//  UIScrollViewExtension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 1/8/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    var scrollDirection: ScrollDirectionT {
        if self.panGestureRecognizer.translation(in: self.superview).x > 0 {
            return .left
        }
        // Scroll right
        else {
            return .right
        }
    }
    
    // TODO: Need to rename the enumaration below
    
    enum ScrollDirectionT {
        case left
        case right
    }
}
