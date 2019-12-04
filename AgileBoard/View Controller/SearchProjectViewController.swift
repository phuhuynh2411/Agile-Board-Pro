//
//  SearchProjectViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/27/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectProjectDelegate {
    
    // User did selecte a project at a index path
    func didSelectdProject(project: Project?)
    
}

class SearchProjectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var projectList: Results<Project>?
    var filteredProjectList: LazyFilterSequence<Results<Project>>?
    
    lazy var realm = try! Realm()
    
    var selectedProject: Project?
    
    var delegate: SelectProjectDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all projects
        projectList = realm.objects(Project.self)
        
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
        
        // Configure table view
        configureTableView()
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configure table view
    
    func configureTableView() {
        
        // Remove the extra separators in the table view
        tableView.tableFooterView = UIView()
    }

}

// MARK: - UI Table View data source

extension SearchProjectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredProjectList?.count ?? 0
        }
        
        return projectList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchProjectTableViewCell
        
        let project = !isFiltering() ? projectList?[indexPath.row] : filteredProjectList?[indexPath.row]
        
        cell.projectNameLabel.text = project?.name
        cell.projectDescription.text = project?.projectDescription
        if let imageName = project?.icon?.name {
            cell.projectImageView.image = UIImage(named: imageName)
        }
        
        // Mark the project as selected one
        if project?.id == selectedProject?.id {
            cell.accessoryType = .checkmark
        }
        // Clean the checkmark if the project is not the selected one
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
}

// MARK: - UI Table View delegate

extension SearchProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Dismiss the search view controller
        searchController.dismiss(animated: false, completion: nil)
        
        let project = !isFiltering() ? projectList?[indexPath.row] : filteredProjectList?[indexPath.row]
        
        delegate?.didSelectdProject(project: project)
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchProjectViewController: UISearchResultsUpdating {
    
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
