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
    
    var filters = [IssueFilter]()
    
    var selectedFilter: IssueFilter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //All
        filters.append(AllIssueFilter(name: "All", imageName: "filter_all"))
        //Due today
        filters.append(DueTodayIssueFilter(name: "Due today", imageName: "filter_due_today"))
        //Due this week
        filters.append(DueThisWeekIssueFilter(name: "Due this week", imageName: "filter_due_this_week"))
        //Created recently
        filters.append(CreatedRecentlyIssueFilter(name: "Created recenlty", imageName: "filter_created_recently"))
        //Updated recently
        filters.append(UpdatedRecentlyIssueFilter(name: "Updated recenlty", imageName: "filter_updated_recently"))
        //Open
        filters.append(OpenIssueFilter(name: "Open", imageName: "filter_open"))
        //Done
         filters.append(DoneIssueFilter(name: "Done", imageName: "filter_done"))
        
        // Remove extra separators
        tableView.tableFooterView = UIView()
        
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterIssueTableViewCell
        
        let filter = filters[indexPath.row]
        cell.nameLabel.text = filter.name
        cell.filterImageView.image = UIImage(named: filter.imageName)

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
        selectedFilter = filters[indexPath.row]
        performSegue(withIdentifier: "IssueTableViewSegue", sender: self)

    }

}
