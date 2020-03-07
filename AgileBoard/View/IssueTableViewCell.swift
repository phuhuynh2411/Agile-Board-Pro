//
//  IssueTableViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/15/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var issueTypeImageView: UIImageView!
    @IBOutlet weak var issueIDLabel: UILabel!
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var numberOfAttachmentsLabel: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make the view background round
        cellBackgroundView.layer.cornerRadius = 7.0
        cellBackgroundView.layer.masksToBounds = true
        
        // remove cell's selection style
        selectionStyle = .none
        
        // Make the cell round
        self.backgroundColor = .none
        self.layer.cornerRadius = 7.0
        self.layer.masksToBounds = true
                
    }
    
}
