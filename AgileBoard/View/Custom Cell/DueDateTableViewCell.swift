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
    
    @IBOutlet weak var titleLabel1: UILabel!
    
    @IBOutlet weak var titleLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell() {
        let empty = dueDateLabel.text!.isEmpty
        // Hide the date
        titleLabel1.isHidden = empty
        dueDateLabel.isHidden = empty
        titleLabel2.isHidden = !empty
    }

}
