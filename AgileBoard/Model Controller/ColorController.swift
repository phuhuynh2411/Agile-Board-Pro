//
//  ColorController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class ColorController {
    var realm: Realm?
    
    static var shared = ColorController()
    
    init() {
        do{
            realm = try Realm()
        } catch{
            print(error)
        }
    }
    
    func createSampleColors() {
        do{
            try realm?.write {
                realm?.add(Color(value: ["hexColor": "#cba8ee"]))
                realm?.add(Color(value: ["hexColor": "#ecab00"]))
                realm?.add(Color(value: ["hexColor": "#b98600"]))
                realm?.add(Color(value: ["hexColor": "#ccccff"]))
                realm?.add(Color(value: ["hexColor": "#ffc0cb"]))
                realm?.add(Color(value: ["hexColor": "#caf4ae"]))
                realm?.add(Color(value: ["hexColor": "#caf4ae"]))
                realm?.add(Color(value: ["hexColor": "#c0efba"]))
                realm?.add(Color(value: ["hexColor": "#bcdebb"]))
                realm?.add(Color(value: ["hexColor": "#cff2a7"]))
                realm?.add(Color(value: ["hexColor": "#c3ee91"]))
                realm?.add(Color(value: ["hexColor": "#9bb7d4"]))
                realm?.add(Color(value: ["hexColor": "#955251"]))
                realm?.add(Color(value: ["hexColor": "#b163a3"]))
                realm?.add(Color(value: ["hexColor": "#decdbe"]))
                realm?.add(Color(value: ["hexColor": "#9b1b30"]))
                realm?.add(Color(value: ["hexColor": "#53b0ae"]))
                realm?.add(Color(value: ["hexColor": "#e8c380"]))
                realm?.add(Color(value: ["hexColor": "#80c3e8"]))
                realm?.add(Color(value: ["hexColor": "#da9e00"]))
                realm?.add(Color(value: ["hexColor": "#ff9e00"]))
                realm?.add(Color(value: ["hexColor": "#ffda00"]))
                realm?.add(Color(value: ["hexColor": "#11111f"]))
                realm?.add(Color(value: ["hexColor": "#0622e6"]))
                realm?.add(Color(value: ["hexColor": "#b2ccff"]))
                realm?.add(Color(value: ["hexColor": "#04179b"]))
                realm?.add(Color(value: ["hexColor": "#071ec9"]))
                realm?.add(Color(value: ["hexColor": "#244ce5"]))
                realm?.add(Color(value: ["hexColor": "#4c89ff"]))
                realm?.add(Color(value: ["hexColor": "#1433a9"]))
                realm?.add(Color(value: ["hexColor": "#003499"]))
                realm?.add(Color(value: ["hexColor": "#0057ff"]))
                realm?.add(Color(value: ["hexColor": "#0f1036"]))
                realm?.add(Color(value: ["hexColor": "#335a87"]))
                realm?.add(Color(value: ["hexColor": "#000000"]))
                realm?.add(Color(value: ["hexColor": "#53b0ae"]))
                realm?.add(Color(value: ["hexColor": "#94b1ee"]))
                realm?.add(Color(value: ["hexColor": "#d8ff2b"]))
                realm?.add(Color(value: ["hexColor": "#e7c5ee"]))
                realm?.add(Color(value: ["hexColor": "#9bb7d4"]))
                realm?.add(Color(value: ["hexColor": "#c74375"]))
                realm?.add(Color(value: ["hexColor": "#bf1932"]))

            }
        }catch{
            print(error)
        }
    }
}
