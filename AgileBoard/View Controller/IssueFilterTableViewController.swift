//
//  FilterIssueTableViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class IssueFilterTableViewController: UITableViewController {
    
    var filters: Results<IssueFilter>?
    
    var selectedFilter: IssueFilter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load all issue filters
        let realm = AppDataController.shared.realm
        filters = realm?.objects(IssueFilter.self)
        
        // Remove extra separators
        tableView.tableFooterView = UIView()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterIssueTableViewCell
        
        if let filter = filters?[indexPath.row] {
            cell.nameLabel.text = filter.name
        }

        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "IssueTableViewSegue" {
            let  issueListTableViewController = segue.destination as! IssueListTableViewController
            issueListTableViewController.filter = selectedFilter
        }
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let filter = filters?[indexPath.row] {
            selectedFilter = filter
            performSegue(withIdentifier: "IssueTableViewSegue", sender: self)
        }
    }

}
