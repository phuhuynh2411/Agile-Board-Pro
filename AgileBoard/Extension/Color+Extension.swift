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
            color(hex: "#cba8ee"),
            color(hex: "#ecab00"),
            color(hex: "#b98600"),
            color(hex: "#ccccff"),
            color(hex: "#ffc0cb"),
            color(hex: "#caf4ae"),
            color(hex: "#caf4ae"),
            color(hex: "#c0efba"),
            color(hex: "#bcdebb"),
            color(hex: "#cff2a7"),
            color(hex: "#c3ee91"),
            color(hex: "#9bb7d4"),
            color(hex: "#955251"),
            color(hex: "#b163a3"),
            color(hex: "#decdbe"),
            color(hex: "#9b1b30"),
            color(hex: "#53b0ae"),
            color(hex: "#e8c380"),
            color(hex: "#80c3e8"),
            color(hex: "#da9e00"),
            color(hex: "#ff9e00"),
            color(hex: "#ffda00"),
            color(hex: "#11111f"),
            color(hex: "#0622e6"),
            color(hex: "#b2ccff"),
            color(hex: "#04179b"),
            color(hex: "#071ec9"),
            color(hex: "#244ce5"),
            color(hex: "#4c89ff"),
            color(hex: "#1433a9"),
            color(hex: "#003499"),
            color(hex: "#0057ff"),
            color(hex: "#0f1036"),
            color(hex: "#335a87"),
            color(hex: "#000000"),
            color(hex: "#53b0ae"),
            color(hex: "#94b1ee"),
            color(hex: "#d8ff2b"),
            color(hex: "#e7c5ee"),
            color(hex: "#9bb7d4"),
            color(hex: "#c74375"),
            color(hex: "#bf1932"),
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
