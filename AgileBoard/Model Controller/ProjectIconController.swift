//
//  ProjectIconController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class ProjectIconController {
    
    static let realm = try! Realm()
    
    static func createSampleIcons() {
        
        let iconList = List<ProjectIcon>()
        let icon1 = ProjectIcon()
        icon1.name = "project_alarm"
        iconList.append(icon1)
        
        let icon2 = ProjectIcon()
        icon2.name = "project_cammera"
        iconList.append(icon2)
        
        let icon3 = ProjectIcon()
        icon3.name = "project_email"
        iconList.append(icon3)
        
        let icon4 = ProjectIcon()
        icon4.name = "project_heart"
        iconList.append(icon4)
        
        let icon5 = ProjectIcon()
        icon5.name = "project_lock"
        iconList.append(icon5)
        
        let icon6 = ProjectIcon()
        icon6.name = "project_photo"
        iconList.append(icon6)
        
        let icon7 = ProjectIcon()
        icon7.name = "project_photo2"
        iconList.append(icon7)
        
        let icon8 = ProjectIcon()
        icon8.name = "project_shield"
        iconList.append(icon8)
        
        let icon9 = ProjectIcon()
        icon9.name = "project_tidy"
        iconList.append(icon9)
        
        let icon10 = ProjectIcon()
        icon10.name = "project_cloud"
        iconList.append(icon10)
        
        do{
            try realm.write {
                realm.add(iconList)
            }
        }catch let error as NSError {
            print(error.description)
        }
    }
}
