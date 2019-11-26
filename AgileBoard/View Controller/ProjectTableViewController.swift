//
//  ProjectTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class ProjectTableViewController: UITableViewController {
    
    var projectList: Results<Project>?
    
    lazy var realm = try! Realm()
    
    var selectedProject: Project?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Load project sample data
        let project = ProjectManager.loadProjectSampleData()
        
        // Clear previous data
        try! realm.write {
            realm.deleteAll()
        }

        // Add th project to realm inside a transaction
        try! realm.write {
            realm.add(project)
        }
        
        // Get all projects from Realm database
        projectList = realm.objects(Project.self)
//        
//        let issue7 = Issue()
//        issue7.summary = "Go shopping on Sunday"
//        let done = Status()
//        done.name = "Done"
//        issue7.status = done
//        issue7.orderNumber = Issue.incrementID()
//        try! realm.write {
//            project.issues.append(issue7)
//        }
        

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProjectTableViewCell
        
        let project = projectList?[indexPath.row]
        cell.projectNameLabel.text = project?.name
        cell.projectDescriptionLabel.text = project?.projectDescription

        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Initialize a selected project at index path
        selectedProject = projectList?[indexPath.row]
        
        performSegue(withIdentifier: Identifier.BoardViewControllerSegue, sender: self)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Make sure the segue is about to go to board view controller
        guard segue.identifier == Identifier.BoardViewControllerSegue else { return }
        
        // Pass the selected project through the board view controller
        let boardViewController = segue.destination as! BoardViewController
        boardViewController.project = selectedProject
     
    }
    

}
