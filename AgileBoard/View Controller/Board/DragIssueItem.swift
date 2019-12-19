//
//  DragIssueItem.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/20/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class DragIssueItem {
    var issueList: List<Issue>
    let indexPath: IndexPath
    let tableView: UITableView
    
    var cell: UITableViewCell
    
    init(issueList: List<Issue>, indexPath: IndexPath, tableView: UITableView, cell: UITableViewCell){
        self.issueList = issueList
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
}
