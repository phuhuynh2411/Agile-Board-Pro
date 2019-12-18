//
//  UITextView+Extension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/18/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    /**
     Size the text view's height to fit its content
     */
    func fitHeightContent() {
        translatesAutoresizingMaskIntoConstraints = false
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        frame.size =  CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.superview?.layoutIfNeeded()
    }
}
