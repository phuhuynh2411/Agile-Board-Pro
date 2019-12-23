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
        let project = Project()
        project.name = name
        project.key = key
        project.projectDescription = "Maecenas faucibus mollis interdum."
        
        let projectIcon = ProjectIcon()
        projectIcon.name = icon
        
        project.icon = projectIcon
        
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
        project.statuses.append(todo)
        project.statuses.append(inprogress)
        project.statuses.append(done)
        project.statuses.append(completed)
        
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
        let issues = [issue1, issue2, issue3, issue4, issue5, issue6, issue7, issue8]
        add(issues: issues, to: project)
        
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
        add(board: board, to: project)
    
    }
    
    func add(issue: Issue, to project: Project) {
        // If the project was not in realm, add it to realm first
        guard add(project: project) != nil else { return }
        
        // Add issue to realm whenever the project has been added to realm sucessfully.
        issue.serial = nextIssueSerial(of: project)
        do {
            try realm.write {
                project.issues.append(issue)
            }
        } catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func add(issues: [Issue], to project: Project) {
        for issue in issues {
            add(issue: issue, to: project)
        }
    }
    
    func add(board: Board, to project: Project) {
        guard add(project: project) != nil else { return }
        // Add board to realm whenever the project has been added to realm sucessfully.
        do {
            try realm.write {
                project.boards.append(board)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func add(project: Project)-> Project? {
        // If the project was not in realm, add it to realm first
        if !realm.objects(Project.self).contains(project) {
            do{
                try realm.write {
                    realm.add(project)
                }
                return project
            }catch{
                print(error)
                return nil
            }
        }
        // If the project was already in realm, do not add it.
        return project
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
    
    func nextIssueSerial(of project: Project)-> Int {
        var max = project.issues.max(ofProperty: "serial") as Int? ?? 0
        max = max == 0 ? 1 : max + 1
        return max
    }
    
    func removeStatus(at index: Int, in project: Project) {
        do{
            try realm.write {
                project.statuses.remove(at: index)
            }
        }catch{
            print(error)
        }
    }
    
}

