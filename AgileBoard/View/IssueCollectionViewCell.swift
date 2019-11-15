//
//  IssueCollectionViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/15/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var issueTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Register custom cell for the issue table view
        let nibName = UINib(nibName: Identifier.IssueTableViewCell, bundle: .main)
        issueTableView.register(nibName, forCellReuseIdentifier: Identifier.IssueTableViewCell)
    }

}
