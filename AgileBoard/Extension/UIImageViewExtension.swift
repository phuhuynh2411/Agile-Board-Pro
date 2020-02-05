//
//  UIImageView.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/17/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
