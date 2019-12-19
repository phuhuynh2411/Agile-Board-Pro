//
//  ProjectManager.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class ProjectController {
    
    public var realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    static var shared = ProjectController()
    
    ///
    /// Load sample data for the project
    ///
    func createSampleProjects() {
        
        let projectController = ProjectController()
        
        projectController.sampleProject(with: "New Project", key: "NP", icon: "project_email")
        projectController.sampleProject(with: "Parturient Ipsum Elit", key: "PIE", icon: "project_alarm")
        projectController.sampleProject(with: "Aenean Pharetra Risus", key: "APR", icon: "project_cloud")
        projectController.sampleProject(with: "Sit Euismod", key: "SE", icon: "default_project_icon")
        projectController.sampleProject(with: "Ornare Purus", key: "OR", icon: "project_photo")
        projectController.sampleProject(with: "Vehicula Elit", key: "VE", icon: "project_photo2")
        
    }
    
    func sampleProject(with name: String, key: String, icon: String) {
        
        // 1. Create a new project
        let project1 = Project()
        project1.name = name
        project1.key = key
        project1.projectDescription = "Maecenas faucibus mollis interdum. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Sed posuere consectetur est at lobortis. Sed posuere consectetur est at lobortis."
        
        let projectIcon = ProjectIcon()
        projectIcon.name = icon
        
        project1.icon = projectIcon
        
        // 2. Create statuses

        let todo = Status()
        todo.name = "TO DO"
        todo.color = Color(value: ["hexColor": "#3498DB"])
        let inprogress = Status()
        inprogress.name = "IN PROGRESS"
        inprogress.color = Color(value: ["hexColor": "#F1C40F"])
        let done = Status()
        done.name = "DONE"
        done.color = Color(value: ["hexColor": "#27AE60"])
        let completed = Status()
        completed.name = "COMPLETED"
        completed.color = Color(value: ["hexColor": "#9bb7d4"])
        
        // Add statuses to project
        project1.statuses.append(todo)
        project1.statuses.append(inprogress)
        project1.statuses.append(done)
        project1.statuses.append(completed)
        
        let issueType1 = IssueType()
        issueType1.name = "Story"
        issueType1.imageName = "issue_story"
        issueType1.standard = true
        issueType1.typeDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna."
        
        // 3. Create issues
        let issue1 = Issue()
        issue1.summary = "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum."
        issue1.status = todo
        issue1.orderNumber = 0
        issue1.type = issueType1
        
        let issue2 = Issue()
        issue2.summary = "Fringilla Fusce"
        issue2.status = todo
        issue2.orderNumber = 1
        issue2.type = issueType1
        
        let issue3 = Issue()
        issue3.summary = "Donec sed odio dui."
        issue3.status = todo
        issue3.orderNumber = 2
        issue3.type = issueType1
        
        let issue4 = Issue()
        issue4.summary = "Curabitur blandit tempus porttitor."
        issue4.status = inprogress
        issue4.orderNumber = 3
        issue4.type = issueType1
        
        let issue5 = Issue()
        issue5.summary = "Nulla vitae elit libero, a pharetra augue."
        issue5.status = inprogress
        issue5.orderNumber = 4
        issue5.type = issueType1
        
        let issue6 = Issue()
        issue6.summary = "Sed posuere consectetur est at lobortis."
        issue6.status = done
        issue6.orderNumber = 5
        issue6.type = issueType1
        
        let issue7 = Issue()
        issue7.summary = "Cras mattis consectetur purus sit amet fermentum."
        issue7.status = completed
        issue7.orderNumber = 6
        issue7.type = issueType1
        
        let issue8 = Issue()
        issue8.summary = "Vestibulum id ligula porta felis euismod semper."
        issue8.status = completed
        issue8.orderNumber = 7
        issue8.type = issueType1
        
        // 4. Add issues to the project
        project1.issues.append(issue1)
        project1.issues.append(issue2)
        project1.issues.append(issue3)
        project1.issues.append(issue4)
        project1.issues.append(issue5)
        project1.issues.append(issue6)
        project1.issues.append(issue7)
        project1.issues.append(issue8)
        
        // 5. Create columns
        let column1 = Column()
        column1.name = "TO DO"
        column1.status = todo
        
        let column2 = Column()
        column2.name = "IN PROGRESS"
        column2.status = inprogress
        
        let column3 = Column()
        column3.name = "DONE"
        column3.status = done
        
        let column4 = Column()
        column4.name = "COMPLETED"
        column4.status = completed
        
        // 6. Create board
        let board = Board()
        board.name = "Default Board"
        board.columns.append(column1)
        board.columns.append(column2)
        board.columns.append(column3)
        board.columns.append(column4)
        
        // 7. Add board to the project
        project1.boards.append(board)
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(project1)
            }
        } catch let error as NSError {
            print(error.description)
        }
    
    }
    
    func add(issue: Issue, to project: Project) {
        
        do {
            try realm.write {
                project.issues.append(issue)
            }
        } catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func delete(project: Project) {
        
        do {
            try realm.write {
                // Delete all referenced objects
                realm.delete(project.issues)
                realm.delete(project.boards)
                realm.delete(project.sprints)
                // Finally delete the project
                realm.delete(project)
            }
        } catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func add(project: Project, _ callback: (_ error: NSError?)->Void){
        
        do {
            try realm.write {
                realm.add(project)
                callback(nil)
            }
        } catch let error as NSError {
            print("Failed adding project with error \(error.description)")
            callback(error)
        }
        
    }
    
    func update(project: Project, by anotherProject: Project, _ callback: (_ error: NSError?)->Void) {
        do {
            try realm.write {
                project.key = anotherProject.key
                project.projectDescription = anotherProject.projectDescription
                project.name = anotherProject.name
                project.icon = anotherProject.icon
                
                callback(nil)
            }
        } catch let error as NSError {
            print("Failed updating project with error \(error.description)")
            callback(error)
        }
    }
    
    func all()->Results<Project>{
        return realm.objects(Project.self)
    }
    
}

