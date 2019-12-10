//
//  AttachmentTableViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/6/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class AttachmentTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var disclosureImageView: UIImageView!
    var isTransform = false
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate collapsable or expandable row
        if isTransform {
            UIView.animate(withDuration: 1) {
                self.layoutIfNeeded()
                self.disclosureImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            }

        }else {
            UIView.animate(withDuration: 1) {
                self.layoutIfNeeded()
                self.disclosureImageView.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
}
