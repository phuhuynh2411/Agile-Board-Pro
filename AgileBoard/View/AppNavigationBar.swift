//
//  AppNavigationBar.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/27/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class AppNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        comomInit()
    }

    func comomInit() {
//        setBackgroundImage(UIImage(), for:.default)
//        shadowImage = UIImage()
//
//        layoutIfNeeded()
        self.setValue(true, forKey: "hidesShadow")

    }
}
