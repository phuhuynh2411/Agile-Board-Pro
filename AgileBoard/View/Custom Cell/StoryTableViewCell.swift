//
//  StoryTableViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var assigneeImageView: UIImageView!
    @IBOutlet weak var mainBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        mainBackgroundView.layer.cornerRadius = 5.0
        mainBackgroundView.layer.masksToBounds = true
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

