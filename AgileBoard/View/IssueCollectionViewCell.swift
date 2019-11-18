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
    @IBOutlet weak var cellHeaderView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cellFooterView: UIView!
        
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
        
    var issueTableViewController: IssueTableViewController?
    
    var cellIsFit = false
    
    var headerFooterHeight: CGFloat {
        return cellHeaderView.frame.height + cellFooterView.frame.height
    }
    
    var tableEstimatedHeight: CGFloat {
        self.frame.height - self.headerFooterHeight
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Register custom cell for the issue table view
        let nibName = UINib(nibName: Identifier.IssueTableViewCell, bundle: .main)
        issueTableView.register(nibName, forCellReuseIdentifier: Identifier.IssueTableViewCell)
        
        // Initilize the issue table view controller
        issueTableViewController = IssueTableViewController(style: .plain)
        
        // Set data source and delegate to the table view
        issueTableView.dataSource = issueTableViewController
        issueTableView.delegate = issueTableViewController
        
        
        // Round the header and footer
        cellHeaderView.layer.cornerRadius = 5.0
        cellHeaderView.layer.masksToBounds = true
        
        cellFooterView.layer.cornerRadius = 5.0
        cellFooterView.layer.masksToBounds = true
        
    }
    
}
