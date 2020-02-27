//
//  AppDataController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class AppDataController {
    
    var realm: Realm?
    
    init() {
        do{
            self.realm  = try Realm()
        }catch let error as NSError {
            print(error)
        }
    }
    
    static var shared = AppDataController()
        
    func createSampleData() {
        
        self.clearRealm()
        
        // Create issue types
        var issueTypes = [IssueType]()
        issueTypes.append(contentsOf: [.story, .epic, .bug, .task])
        self.add(toRealm: issueTypes)
        
        // Create project's icon
        var icons = [ProjectIcon]()
        icons.append(contentsOf: [.standard, .alarm, .cammera, .email, .heart,
                                  .lock, .photo, .photo2, .shield, .tidy, .cloud])
        self.add(toRealm: icons)
        
        // Add priorities
        var priorities = [Priority]()
        priorities.append(contentsOf: [.highest, .high, .medium, .low, .lowest])
        self.add(toRealm: priorities)
        
        // Add color
        self.add(toRealm: Color.colors)
        
        // Add five sample projects
        self.add(sampleProjects: 10)
    }
    
    func clearRealm(){
        do{
            try realm?.write {
                realm?.deleteAll()
            }
        }catch{
            print(error)
        }
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
        // Create sample Projects
        let key = Lorem.words(5).prefix(3).uppercased()
        let name = Lorem.sentence.prefix(30)
        let project = Project(name: String(name), description: Lorem.sentences(2), key: String(key))
        project.isSample    = true
        project.icon        = .standard
        
        self.add(toRealm: [project])
    }
    
    func add(sampleProjects number: Int) {
        for _ in 0..<number {
            self.addSampleProject()
        }
    }
}
