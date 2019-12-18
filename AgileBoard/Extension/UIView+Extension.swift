//
//  UIView+Extension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/18/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
