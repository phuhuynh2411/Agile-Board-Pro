//
//  Animations.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/11/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import UIKit

class Animations {
    static func requireUserAtencion(on onView: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: onView.center.x - 10, y: onView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: onView.center.x + 10, y: onView.center.y))
        onView.layer.add(animation, forKey: "position")
    }
}
