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
    @IBOutlet weak var assigneeImageVIew: UIImageView!
    @IBOutlet weak var issueTypeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellBackgroundView.layer.cornerRadius = 7.0
        cellBackgroundView.layer.masksToBounds = true
        
        selectionStyle = .none
        //self.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.1)
        self.backgroundColor = .none
        self.layer.cornerRadius = 7.0
        self.layer.masksToBounds = true
        

        // Adjust selected cell's background view
        // self.selectedBackgroundView?.layer.cornerRadius = 7.0
        // self.selectedBackgroundView?.layer.masksToBounds = true
                
    }
    
}
