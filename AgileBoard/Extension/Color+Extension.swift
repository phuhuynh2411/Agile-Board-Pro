//
//  Color+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Color {
    
    static var todo:           Color { return .color(hex: "#3498db") }
    static var inprogress:     Color { return .color(hex: "#f1c40f") }
    static var done:           Color { return .color(hex: "#27ae60") }
    
    static var colors: [Color] {
        
        return [
            Color(value: ["hexColor": "#cba8ee"]),
            Color(value: ["hexColor": "#ecab00"]),
            Color(value: ["hexColor": "#b98600"]),
            Color(value: ["hexColor": "#ccccff"]),
            Color(value: ["hexColor": "#ffc0cb"]),
            Color(value: ["hexColor": "#caf4ae"]),
            Color(value: ["hexColor": "#caf4ae"]),
            Color(value: ["hexColor": "#c0efba"]),
            Color(value: ["hexColor": "#bcdebb"]),
            Color(value: ["hexColor": "#cff2a7"]),
            Color(value: ["hexColor": "#c3ee91"]),
            Color(value: ["hexColor": "#9bb7d4"]),
            Color(value: ["hexColor": "#955251"]),
            Color(value: ["hexColor": "#b163a3"]),
            Color(value: ["hexColor": "#decdbe"]),
            Color(value: ["hexColor": "#9b1b30"]),
            Color(value: ["hexColor": "#53b0ae"]),
            Color(value: ["hexColor": "#e8c380"]),
            Color(value: ["hexColor": "#80c3e8"]),
            Color(value: ["hexColor": "#da9e00"]),
            Color(value: ["hexColor": "#ff9e00"]),
            Color(value: ["hexColor": "#ffda00"]),
            Color(value: ["hexColor": "#11111f"]),
            Color(value: ["hexColor": "#0622e6"]),
            Color(value: ["hexColor": "#b2ccff"]),
            Color(value: ["hexColor": "#04179b"]),
            Color(value: ["hexColor": "#071ec9"]),
            Color(value: ["hexColor": "#244ce5"]),
            Color(value: ["hexColor": "#4c89ff"]),
            Color(value: ["hexColor": "#1433a9"]),
            Color(value: ["hexColor": "#003499"]),
            Color(value: ["hexColor": "#0057ff"]),
            Color(value: ["hexColor": "#0f1036"]),
            Color(value: ["hexColor": "#335a87"]),
            Color(value: ["hexColor": "#000000"]),
            Color(value: ["hexColor": "#53b0ae"]),
            Color(value: ["hexColor": "#94b1ee"]),
            Color(value: ["hexColor": "#d8ff2b"]),
            Color(value: ["hexColor": "#e7c5ee"]),
            Color(value: ["hexColor": "#9bb7d4"]),
            Color(value: ["hexColor": "#c74375"]),
            Color(value: ["hexColor": "#bf1932"]),
            todo,
            inprogress,
            done
        ]
        
    }
    
    static func findColor(by hex: String)->Color? {
        let realm = AppDataController.shared.realm
        
        if let color = realm?.objects(Color.self).filter({ (color) -> Bool in
            color.hexColor.lowercased() == hex.lowercased()
        }).first {
            return color
        }else {
            return nil
        }
    }
    
    static func color(hex: String) -> Color {
        if let color = findColor(by: hex) { return color }
        
        let color = Color()
        color.hexColor = hex
        return color
    }
}
