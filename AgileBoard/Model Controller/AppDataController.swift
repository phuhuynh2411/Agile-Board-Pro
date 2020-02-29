//
//  AppDataController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import RealmSwift

class AppDataController {
    
    var realm: Realm?
    
    static var shared = AppDataController()
    
    init() {
        do{ self.realm  = try Realm()
        }catch { print(error) }
    }
    
    func startUp() {
        self.clearRealm()
        
        // Create issue types
        let issueTypes: [IssueType] = [.story, .epic, .bug, .task]
        self.add(toRealm: issueTypes)
        
        // Create project's icon
        let icons: [ProjectIcon] = [.standard, .alarm, .cammera, .email, .heart,
        .lock, .photo, .photo2, .shield, .tidy, .cloud]
        self.add(toRealm: icons)
        
        // Add priorities
        let priorities: [Priority] = [.highest, .high, .medium, .low, .lowest]
        self.add(toRealm: priorities)
        
        // Add color
        self.add(toRealm: Color.colors)
    }
    
    func clearRealm(){
        do{
            try realm?.write { realm?.deleteAll() }
        } catch { print(error) }
    }

    func add(toRealm objects: [Object]) {
        for object in objects {
            if object.realm == nil {
                do{ try realm?.write{ realm?.add(object) }
                }catch{ print(error) }
            }
        }
    }
    
    private func addSampleProject(){
        let key             = Lorem.words(5).prefix(3).uppercased()
        let name            = Lorem.sentence.prefix(30)
        
        let project         = Project(name: String(name), description: Lorem.sentences(2), key: String(key))
        project.isSample    = true
        project.icon        = .standard
        
        self.add(toRealm: [project])
    }
    
    func add(sampleProjects number: Int) {
        for _ in 0..<number { self.addSampleProject() }
    }
}
