//
//  UIColor+Extention.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/13/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(hexString: String, alpha: CGFloat = 1.0) {
       let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
       let scanner = Scanner(string: hexString)
       if (hexString.hasPrefix("#")) {
         scanner.scanLocation = 1
       }
       var color: UInt32 = 0
       scanner.scanHexInt32(&color)
       let mask = 0x000000FF
       let r = Int(color >> 16) & mask
       let g = Int(color >> 8) & mask
       let b = Int(color) & mask
       let red = CGFloat(r) / 255.0
       let green = CGFloat(g) / 255.0
       let blue = CGFloat(b) / 255.0
       self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
       var r:CGFloat = 0
       var g:CGFloat = 0
       var b:CGFloat = 0
       var a:CGFloat = 0
       getRed(&r, green: &g, blue: &b, alpha: &a)
       let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
       return String(format:"#%06x", rgb)
    }
    
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50 ? true : false
    }
    
    // Returns black if the given background color is light or white if the given color is dark
    func textColor(bgColor: UIColor) -> UIColor {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        bgColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
        brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000;
        if (brightness < 0.5) {
            return UIColor.white
        }
        else {
            return UIColor.black
        }
    }
}
