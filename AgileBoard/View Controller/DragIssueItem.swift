//
//  DragIssueItem.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/20/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class DragIssueItem {
    var issueList: NSMutableArray?
    let indexPath: IndexPath
    let tableView: UITableView
    
    init(issueList: NSMutableArray?, indexPath: IndexPath, tableView: UITableView){
        self.issueList = issueList
        self.indexPath = indexPath
        self.tableView = tableView
    }
}
