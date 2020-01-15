//
//  IssueListTableViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class IssueListTableViewController: UITableViewController {
    
    var filter: IssueFilter?
    
    private var sections: [String] = []
    private var sortedIssues: Results<Issue>!
    private lazy var dictionary: Dictionary<String, [Issue]> = [:]
    
    // Load items partially
    private let numberOfFetchItems: Int = 10
    private var offset: Int = 0
    
    // Cell label
    var defaultLabelColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cell
        tableView.register(UINib(nibName: "IssueListTableViewCell", bundle: nil), forCellReuseIdentifier: C.issueCell)
        
        // Remove extra saparetors
        tableView.tableFooterView = UIView()
        
        // Update navigation title
        navigationItem.title = filter?.name
        
        // Sort issue by date
        sortedIssues = filter?.issues
        loadMoreItems()

    }

    // MARK: - Helper Methods
    
    /**
     Arranges an issue into the dictionary
     */
    private func arrange(_ issue: Issue) {
        
        guard let filter = filter else { return }
        
        let sectionKey = filter.sectionFor(issue)
        
        // Create a new section if it does not exist
        if sections.first(where: { $0 == sectionKey }) == nil {
            sections.append(sectionKey)
        }
        
        // Add issue in section
        if dictionary[sectionKey] != nil {
            dictionary[sectionKey]?.append(issue)
        }else {
            dictionary[sectionKey] = [issue]
        }
    }
    
    private func loadMoreItems(){
        DispatchQueue.main.async {
            self.fetchDataAsync(completion: self.fetchCompletion(items:))
        }
    }
    
    private func fetchCompletion(items: LazyFilterSequence<Results<Issue>>?) {
        if let batchItems = items {
            appendNewData(newItems: batchItems)
        } else {
            print("There are no items found.")
        }
    }
    
    private func appendNewData(newItems: LazyFilterSequence<Results<Issue>>) {
        // Arrange new items into sections
        for item in newItems {
            arrange(item)
        }
        
        // Increase offset
        offset += newItems.count
        print("Increased the offset to \(offset).")
        
        // Insert new items into the table view
        tableView.reloadData()
        print("Reloaded the table view.")
    }
    
    private func fetchDataAsync(completion: (_ items: LazyFilterSequence<Results<Issue>>?)->Void) {
        // Determine the fetching range of items
        let start = offset
        let end = offset + numberOfFetchItems
        print("Trying loading item from \(start) to \(end)")
        
        // Find all of items in the above range
        let batchItems = sortedIssues.filter { (issue) -> Bool in
            if let index = self.sortedIssues?.index(of: issue) {
                return index >= start && index <= end
            }else {
                return false
            }
        }
        
        guard batchItems.count > 0 else {
            print("There are no item in the range.")
            completion(nil)
            return
        }
        
        print("Found: \(batchItems.count) items.")
        
        completion(batchItems)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sections[section]
        return dictionary[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.issueCell, for: indexPath) as! IssueListTableViewCell
        
        // Store the default label
        if defaultLabelColor == nil {
            defaultLabelColor = cell.summaryLabel.textColor
        }
        
        let key = sections[indexPath.section]
        
        if let issue = dictionary[key]?[indexPath.row] {
            
            if let status = issue.status, status.markedAsDone == true {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: issue.summary)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.summaryLabel.attributedText = attributeString
                cell.summaryLabel.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
            }else {
                cell.summaryLabel.attributedText =  .none
                cell.summaryLabel.textColor = defaultLabelColor
                cell.summaryLabel.text = issue.summary
            }
            
            cell.issueIdLabel.text = issue.issueID
            
            if let typeImageName = issue.type?.imageName {
                cell.typeImageView.image = UIImage(named: typeImageName)
            }
            if let prioryImageName = issue.priority?.imageName {
                cell.priorityImageView.image = UIImage(named: prioryImageName)
            }
            
            cell.statusButton.setTitle(issue.status?.name, for: .normal)
        }
        
        // If it is the last item, loads more items
        if indexPath.section == sections.count - 1,
        indexPath.row == (dictionary[key]?.count ?? 0) - 1 {
            loadMoreItems()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
