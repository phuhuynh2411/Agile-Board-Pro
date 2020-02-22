//
//  IssueCalendarTableViewCell.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import SwipeCellKit

class IssueCalendarTableViewCell: SwipeTableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var titleLabel          : UILabel = {
        let label = UILabel()
        label.text = "Issue Summary"
        label.font = UIFont.systemFont(ofSize: 17)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    let typeImageView            = UIImageView()
    let prioriyImageView         : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var statusImageView     : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3.0
        return imageView
    }()
    lazy var idLabel             : UILabel = {
        let label = UILabel()
        label.text = "FT-0001"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.officialApplePlaceholderGray
        return label
    }()
    lazy var statusLabel         : UILabel = {
        let label = UILabel()
        label.text = "In progress"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.systemBlue
        return label
    }()
    
    let verticalStackView = UIStackView()
    let horizontalStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        
        verticalStackView.distribution = .fillEqually
        verticalStackView.alignment = .leading
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        
        addSubview(typeImageView)
        addSubview(verticalStackView)
        
        horizontalStackView.addArrangedSubview(idLabel)
        horizontalStackView.addArrangedSubview(prioriyImageView)
        horizontalStackView.addArrangedSubview(statusImageView)
        horizontalStackView.addArrangedSubview(statusLabel)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.translatesAutoresizingMaskIntoConstraints = false

        verticalStackView.translatesAutoresizingMaskIntoConstraints     = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints   = false
        titleLabel.translatesAutoresizingMaskIntoConstraints            = false
        typeImageView.translatesAutoresizingMaskIntoConstraints         = false
        prioriyImageView.translatesAutoresizingMaskIntoConstraints      = false
        statusImageView.translatesAutoresizingMaskIntoConstraints       = false
        idLabel.translatesAutoresizingMaskIntoConstraints               = false
        statusLabel.translatesAutoresizingMaskIntoConstraints           = false
        
        typeImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        typeImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        typeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        typeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        verticalStackView.leadingAnchor.constraint(equalTo: typeImageView.trailingAnchor, constant: 8).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        //verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        //verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        prioriyImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        prioriyImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        statusImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        statusImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }
}
