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
    @IBOutlet weak var collectionView: AttachmentCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }



}
