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
    var issueList: Results<Issue>?
    let indexPath: IndexPath
    let tableView: UITableView
    
    init(issueList: Results<Issue>?, indexPath: IndexPath, tableView: UITableView){
        self.issueList = issueList
        self.indexPath = indexPath
        self.tableView = tableView
    }
}
