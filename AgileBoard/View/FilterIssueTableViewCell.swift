//
//  FilterIssueTableViewCell.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class FilterIssueTableViewCell: UITableViewCell {

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
