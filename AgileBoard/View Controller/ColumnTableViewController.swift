//
//  RowTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ColumnTableViewController: UITableViewController {
    
    var issueList: [Issue]?
    
    var columnIndexPath: IndexPath?
    
    // MARK: - Init Methods
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        // Add your code here
    }
    
    // MARK: - Supporting Methods
    func tableView(reloadDataAt indexPath: IndexPath, withIssues issueList: [Issue]) {
        
        columnIndexPath = indexPath
        self.issueList = issueList
        
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StoryTableViewCell
        
        cell.summaryLabel.text = issueList?[indexPath.row].summary
        
        return cell
    }
    
}
