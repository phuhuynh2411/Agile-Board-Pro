//
//  UIDevice+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 3/2/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var info: String {
        let deviceInfo = """
            \n\n
            ----------------------------
            \(name)
            \(systemName) \(systemVersion)
            """
        return deviceInfo
    }
}
