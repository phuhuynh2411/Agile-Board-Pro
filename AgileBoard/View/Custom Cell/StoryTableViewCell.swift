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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
        self.contentView.backgroundColor = UIColor.red
        //self.contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

