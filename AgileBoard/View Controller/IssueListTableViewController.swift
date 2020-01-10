//
//  IssueListTableViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

struct FilterKey: Hashable {
    var order: Int
    var key: String
    
    init(_ order: Int, _ key: String) {
        self.order = order
        self.key = key
    }
}

class IssueListTableViewController: UITableViewController {
    
    var issues: Results<Issue>?
    var filter: IssueFilter?
    
    private var sections: [FilterKey] = []
    private var sortedIssues: Results<Issue>?
    
    private var dictionary: Dictionary<FilterKey, [Issue]>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cell
        tableView.register(UINib(nibName: "IssueListTableViewCell", bundle: nil), forCellReuseIdentifier: C.issueCell)
        
        // Load all issues
        let realm = AppDataController.shared.realm
        issues = realm?.objects(Issue.self)
        
        // Remove extra saparetors
        tableView.tableFooterView = UIView()
        
        // Update navigation title
        navigationItem.title = filter?.name
        
        // Sort issue by date
        sortedIssues = issues?.sorted(byKeyPath: "createdDate", ascending: true)
        
        dictionary = Dictionary(grouping: sortedIssues!, by: { (issue: Issue) ->FilterKey in
            let dateFormater = DateFormatter()
            dateFormater.timeStyle = .none
            
            let calendar = Calendar.current
            if calendar.isDateInToday(issue.createdDate) {
                let name = "Today"
                return section(for: name)
                
            } else if calendar.isDateInTomorrow(issue.createdDate) {
                let name = "Tomorrow"
                return section(for: name)
                
            } else if calendar.isDateInThisWeek(issue.createdDate) {
                let name = "This week"
                return section(for: name)
                
            } else if calendar.isDateInNextWeek(issue.createdDate) {
                let name = "Next Week"
                return section(for: name)
                
            } else if calendar.isDateInThisMonth(issue.createdDate) {
                let name = "This Month"
                return section(for: name)
                
            } else if calendar.isDateInNextMonth(issue.createdDate) {
                let name = "Next Month"
                return section(for: name)

            } else {
                dateFormater.dateFormat = "MMMM yyyy"
                let name = dateFormater.string(from: issue.createdDate)
                return section(for: name)
            }
            
        })

    }

    // MARK: - Helper Methods
    
    private func section(for key: String)->FilterKey {
        if let section = sections.first(where: { $0.key == key }) {
            return section
        }else{
            let section = FilterKey(sections.count, key)
            sections.append(section)
            return section
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sections[section]
        
        return dictionary?[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.issueCell, for: indexPath) as! IssueListTableViewCell
        let key = sections[indexPath.section]
        if let issue = dictionary?[key]?[indexPath.row] {
            
            cell.summaryTextField.text = issue.summary
            cell.issueIdLabel.text = issue.issueID
            if let typeImageName = issue.type?.imageName {
                cell.typeImageView.image = UIImage(named: typeImageName)
            }
            if let prioryImageName = issue.priority?.imageName {
                cell.priorityImageView.image = UIImage(named: prioryImageName)
            }
            cell.statusButton.setTitle(issue.status?.name, for: .normal)
            
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].key
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    struct CellIdentifier {
        static let issueCell = "IssueCell"
    }
    typealias C = CellIdentifier
}
