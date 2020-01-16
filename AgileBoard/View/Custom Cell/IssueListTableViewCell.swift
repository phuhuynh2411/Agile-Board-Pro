//
//  IssueListTableViewCell.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import SwipeCellKit

class IssueListTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var issueIdLabel: UILabel!
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
