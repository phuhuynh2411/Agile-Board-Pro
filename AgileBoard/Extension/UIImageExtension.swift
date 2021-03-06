//
//  UIImageExtension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/6/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

extension UIImage {
        
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
