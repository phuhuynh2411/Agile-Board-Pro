//
//  IssueCalendarTableViewCell.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class IssueCalendarTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let titleLabel          = UILabel()
    let typeImageView       = UIImageView()
    let prioriyImageView    = UIImageView()
    let statusImageView     = UIImageView()
    let idLabel             = UILabel()
    let statusLabel         = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(typeImageView)
        addSubview(prioriyImageView)
        addSubview(statusImageView)
        addSubview(idLabel)
        addSubview(statusLabel)
        
        
    }
}
