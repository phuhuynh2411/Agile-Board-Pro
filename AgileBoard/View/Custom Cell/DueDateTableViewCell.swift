//
//  DueDateTableViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class DueDateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
