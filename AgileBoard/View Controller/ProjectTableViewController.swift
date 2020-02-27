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
    
    lazy var realm = AppDataController.shared.realm
    
    var selectedProject: Project?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let projectController = ProjectController()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Get all projects from Realm database
        projectList = realm?.objects(Project.self)
       
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
        if let icon = project?.icon {
            cell.projectImageView.image = UIImage(named: icon.name)
        }
        cell.idLabel.text = project?.key

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
        
        if segue.identifier == Identifier.BoardViewControllerSegue {
            // Pass the selected project through the board view controller
            let boardViewController = segue.destination as! BoardViewController
            boardViewController.project = selectedProject
        }
        else if segue.identifier == Identifier.EditProjectSegue {
            let navigationController = segue.destination as! UINavigationController
            let addProjectTableViewController = navigationController.topViewController as! ProjectDetailTableViewController
            
            addProjectTableViewController.project = selectedProject
            addProjectTableViewController.delegate = self
        }
        else if segue.identifier == Identifier.AddProjectSegue {
            let navigationController = segue.destination as! UINavigationController
            let addProjectTableViewController = navigationController.topViewController as! ProjectDetailTableViewController
            
            addProjectTableViewController.delegate = self
        }
     
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
            guard let project = self.projectList?[indexPath.row] else { return }
            
            let alertController = UIAlertController(title: "", message: "Are you sure you want to delete this project permanently?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                do{
                    try project.remove()
                }catch{
                    print(error)
                    return
                }
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            self.selectedProject = self.projectList?[indexPath.row]
            self.performSegue(withIdentifier: Identifier.EditProjectSegue, sender: self)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return orientation == .right ? [deleteAction] : [editAction]
    }

}

// MARK: - Add Project Delegate

extension ProjectTableViewController: ProjectDetailDelegate {
    
    func didAdd(_ project: Project) {
        do{
            try realm?.write{ realm?.add(project) }
        } catch{ print(error) }
        tableView.reloadData()
    }
    
    func didEdit(_ project: Project) {
        tableView.reloadData()
    }
}
