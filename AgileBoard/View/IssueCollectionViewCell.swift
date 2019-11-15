//
//  IssueCollectionViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/15/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var issueTableView: IssueTableView!
    var issueTableViewController: IssueTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Register custom cell for the issue table view
        let nibName = UINib(nibName: Identifier.IssueTableViewCell, bundle: .main)
        issueTableView.register(nibName, forCellReuseIdentifier: Identifier.IssueTableViewCell)
        
        // Initilize the issue table view controller
        issueTableViewController = IssueTableViewController(style: .plain)
        
        // Set data source and delegate to the table view
        issueTableView.dataSource = issueTableViewController
        issueTableView.delegate = issueTableViewController
        
    }

}
