//
//  UIImageExtension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/6/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static func image(filePath: String) -> UIImage? {
        if let url = URL(string: filePath) {
            guard let data = try? Data(contentsOf: url) else { return nil }
            return UIImage(data: data)
        }
       
        return nil
    }
}
