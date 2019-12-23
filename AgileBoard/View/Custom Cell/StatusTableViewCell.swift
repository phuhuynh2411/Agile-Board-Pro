//
//  StatusTableViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import SwipeCellKit

class StatusTableViewCell: SwipeTableViewCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusImageView.layer.cornerRadius = 5.0
        statusImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
