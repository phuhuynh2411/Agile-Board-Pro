//
//  SearchProjectTableViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/28/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class SearchProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Removes the selected style when user taps on the row
        self.selectionStyle = .none
    }

}
