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
        todo.color = ColorController.shared.todoColor()
        let inprogress = Status()
        inprogress.name = "IN PROGRESS"
        inprogress.color = ColorController.shared.inprogressColor()
        let done = Status()
        done.name = "DONE"
        done.color = ColorController.shared.doneColor()
        
        // Add statuses to project
        project.statuses.append(todo)
        project.statuses.append(inprogress)
        project.statuses.append(done)
        
        // Create issue types
        let story = IssueTypeController.shared.story()
        let epic = IssueTypeController.shared.epic()
        let task = IssueTypeController.shared.task()
        let bug = IssueTypeController.shared.bug()
        // Add issue types to project
        project.issueTypes.append(objectsIn: [story, epic, task, bug])
        
        // 3. Create issues
        let issue1 = Issue()
        issue1.summary = "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum."
        issue1.status = todo
        issue1.orderNumber = 0
        issue1.type = story
        
        let issue2 = Issue()
        issue2.summary = "Fringilla Fusce"
        issue2.status = todo
        issue2.orderNumber = 1
        issue2.type = story
        
        let issue3 = Issue()
        issue3.summary = "Donec sed odio dui."
        issue3.status = todo
        issue3.orderNumber = 2
        issue3.type = story
        
        let issue4 = Issue()
        issue4.summary = "Curabitur blandit tempus porttitor."
        issue4.status = inprogress
        issue4.orderNumber = 3
        issue4.type = story
        
        let issue5 = Issue()
        issue5.summary = "Nulla vitae elit libero, a pharetra augue."
        issue5.status = inprogress
        issue5.orderNumber = 4
        issue5.type = story
        
        let issue6 = Issue()
        issue6.summary = "Sed posuere consectetur est at lobortis."
        issue6.status = done
        issue6.orderNumber = 5
        issue6.type = story
        
        // 4. Add issues to the project
        let issues = [issue1, issue2, issue3, issue4, issue5, issue6]
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
        
        // 6. Create board
        let board = Board()
        board.name = "Main Board"
        board.columns.append(column1)
        board.columns.append(column2)
        board.columns.append(column3)
        
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
    
    func add(status: Status, to project: Project) {
        do{
            try realm.write {
                project.statuses.append(status)
            }
        }catch{
            print(error)
        }
    }
    
}

