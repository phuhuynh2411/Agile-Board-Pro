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
    
    var scrollDirection: ScrollDirection {
        if self.panGestureRecognizer.translation(in: self.superview).x > 0 {
            return .left
        }
        // Scroll right
        else {
            return .right
        }
    }
    
    enum ScrollDirection {
        case left
        case right
    }
}
