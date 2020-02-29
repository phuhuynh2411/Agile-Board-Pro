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
    @IBOutlet weak var numberOfDueButton: UIButton!
    
    var numberOfDueIssue: Int = 0 {
        didSet{
            self.backgroundColorForDueButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numberOfDueButton.layer.cornerRadius = 5.0
        numberOfDueButton.clipsToBounds = true
        numberOfDueButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColorForDueButton()
    }
    
    private func backgroundColorForDueButton() {
        if numberOfDueIssue > 0 {
            numberOfDueButton.setTitle("\(numberOfDueIssue)", for: .normal)
            numberOfDueButton.backgroundColor = .red
        } else{
            numberOfDueButton.setTitle("", for: .normal)
            numberOfDueButton.backgroundColor = .none
        }
    }

}
