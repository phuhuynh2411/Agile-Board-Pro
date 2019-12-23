//
//  ProjectTableViewCellv2.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/20/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ProjectTableViewCellv2: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
