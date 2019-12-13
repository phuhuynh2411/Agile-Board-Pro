//
//  StartDateTableViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/13/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class StartDateTableViewCell: UITableViewCell {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell() {
        let empty = startDateLabel.text!.isEmpty
        
        titleLabel2.isHidden = !empty
        titleLabel1.isHidden = empty
        startDateLabel.isHidden = empty
        
    }
}
