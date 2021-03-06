//
//  FilterIssueTableViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import NotificationBannerSwift

class IssueFilterTableViewController: UITableViewController {
    
    var filters = [IssueFilter]()
    
    var selectedFilter: IssueFilter?
    
    var isActiveSearch = false
    
    var selectedIssue: Issue?

    // MARK: - View Methods
    
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
        
        //Story
        filters.append(StoryFilter(name: "Story", imageName: "issue_filter_story"))
        //Task
        filters.append(TaskFilter(name: "Task", imageName: "issue_filter_task"))
        //Epic
        filters.append(EpicFilter(name: "Epic", imageName: "issue_filter_epic"))
        //Bug
        filters.append(BugFilter(name: "Bug", imageName: "issue_filter_bug"))
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        // Auto set the filter to the first one
        selectedFilter = filters.first
        isActiveSearch = true
        performSegue(withIdentifier: S.issueList, sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: S.addIssue, sender: self)
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
        
        if (filter as? DueTodayIssueFilter) != nil || (filter as? DueThisWeekIssueFilter) != nil,
            let count = filter.issues?.count {
            cell.numberOfDueIssue = count
        } else {
            cell.numberOfDueIssue = 0
        }

        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == S.issueList {
            let  issueListTableViewController = segue.destination as! IssueListTableViewController
            issueListTableViewController.filter = selectedFilter
            issueListTableViewController.isActiveSearch = isActiveSearch
        } else if segue.identifier == S.addIssue {
            let navigationController = segue.destination as! UINavigationController
            let vc =  navigationController.topViewController as! IssueDetailTableViewController

            let issue = Issue()
            issue.type = .standard
            issue.priority = .standard
            issue.startDate = Date()
            issue.endDate = Date()
            
            vc.issue = issue
            vc.delegate = self
            
        } else if segue.identifier == S.editIssue {
            let navigationController = segue.destination as! UINavigationController
            let vc =  navigationController.topViewController as! IssueDetailTableViewController
            
            guard let project = selectedIssue?.projectOwners.first, let issue = selectedIssue else {
                fatalError("There was something wrong. The project or issue is nil.")
            }
            vc.issue = issue
            vc.project = project
            vc.delegate = self
        }
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilter = filters[indexPath.row]
        // Do not activate search controller if selecting on the filter
        isActiveSearch = false
        performSegue(withIdentifier: S.issueList, sender: self)
    }
    
    struct SegueIdentifier {
        static let issueList = "IssueTableViewSegue"
        static let addIssue = "AddIssueSegue"
        static let editIssue = "EditIssueSegue"
    }
    typealias S = SegueIdentifier

}

// MARK: - IssueDetailDelegate

extension IssueFilterTableViewController: IssueDetailDelegate {
    
    func didAdd(_ issue: Issue, to project: Project?) {
        // Set issue's status to the first project's status
        issue.status = project?.statuses.first
        
        do{
            try project?.add(issue)
        }catch {
            print(error)
            return
        }
        
        // Set the selected issue to the new issue
        self.selectedIssue = issue
        // Add issue to sortedIssues array
        let view: CreatedIssueView = .fromNib()
        view.issueIDLabel.text = issue.issueID
        if let typeImageName = issue.type?.imageName {
            view.typeImageView.image = UIImage(named: typeImageName)
        }
        
        let banner = FloatingNotificationBanner(customView: view)
        banner.show()
        banner.onTap = {
            self.tappedOnBanner()
        }
    }
    
    func didModify(_ issue: Issue) {
        
    }
    
    func tappedOnBanner() {
        performSegue(withIdentifier: S.editIssue, sender: self)
    }
    
}
