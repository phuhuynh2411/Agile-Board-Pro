//
//  ProjectTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ProjectTableViewController: UITableViewController {
    
    var projectList: Results<Project>?
    
    var filteredProjectList: LazyFilterSequence<Results<Project>>?
    
    lazy var realm = try! Realm()
    
    var selectedProject: Project?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let projectController = ProjectController()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Get all projects from Realm database
        projectList = realm.objects(Project.self)
       
        // Configure search view controller
        configureSearchViewController()
        
        // Configure table view
        configureTableView()

    }
    
    // MARK: - Configure Search View Controller
    
    func configureSearchViewController() {
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search project"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
    }
    
    // MARK: - Configure Table View
    
    func configureTableView() {
        
        // Remove the extra separators in the table view
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IB Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Identifier.AddProjectSegue, sender: self)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRows = !isFiltering() ? projectList?.count : filteredProjectList?.count
        return numberOfRows ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProjectTableViewCell
        cell.delegate = self
        
        let project = !isFiltering() ? projectList?[indexPath.row] : filteredProjectList?[indexPath.row]
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
        selectedProject = !isFiltering() ? projectList?[indexPath.row] : filteredProjectList?[indexPath.row]
        
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

// MARK: - UISearchResultsUpdating

extension ProjectTableViewController: UISearchResultsUpdating {
    
    func isFiltering() -> Bool {
        return searchController.isActive && !isEmptySearchBar()
    }
    
    func isEmptySearchBar() -> Bool {
        return searchController.searchBar.text!.isEmpty
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filteredProjectList = projectList?.filter({ (project) -> Bool in
            project.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()

    }
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
}

// MARK: - SwipeTableViewCellDelegate

extension ProjectTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        // guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let project = self.projectList?[indexPath.row]
            ProjectController.delete(project: project!)
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return orientation == .right ? [deleteAction] : [editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        // Delete project
        if orientation == .right {
            options.expansionStyle = .destructive
            options.transitionStyle = .border
        }
        // Edit project
        else {
            options.expansionStyle = .selection
            options.transitionStyle = .border
        }
        return options
    }
    
}
