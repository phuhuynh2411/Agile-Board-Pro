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
    @IBOutlet weak var countLabel: UILabel!
     
    /// A height of the cell's header and footer
    var headerFooterHeight: CGFloat {
        return cellHeaderView.frame.height + cellFooterView.frame.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure the appearance of the cell
        configureCell()
    }
    
    fileprivate func configureCell() {
        
        // Round the header and footer
        cellHeaderView.layer.cornerRadius = 5.0
        cellHeaderView.layer.masksToBounds = true
        cellHeaderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
        
        cellFooterView.layer.cornerRadius = 5.0
        cellFooterView.layer.masksToBounds = true
        cellFooterView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // bottom left corner, bottom right corner respectively
        
        // Pass the issue count label to the table view
        issueTableView.issueCountLabel = countLabel
        
    }
    
}
