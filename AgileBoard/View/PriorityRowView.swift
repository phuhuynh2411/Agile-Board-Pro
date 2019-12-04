//
//  PriorityRowView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/4/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

protocol PriorityViewDelegate {
    func didSelectPriority()
}

class PriorityRowView: UIView {
    
    var iconImageView: UIImageView?
    var nameLabel: UILabel?
    var rightArrowImageView: UIImageView?
    var titleLabel: UILabel?
    
    var delegate: PriorityViewDelegate?
    var priority: Priority?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(priority: Priority?) {
        self.init()
        self.priority = priority
        commonInit()
    }
    
    private func commonInit() {
        setUpView()
        setUpGesture()
    }
    
    private func setUpView() {
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        //backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView = UIImageView()
        iconImageView?.translatesAutoresizingMaskIntoConstraints = false
        if let imageName = priority?.imageName {
            iconImageView?.image = UIImage(named: imageName)
        }
        iconImageView?.contentMode = .scaleAspectFit
        nameLabel = UILabel()
        nameLabel?.text = priority?.name
        nameLabel?.font = UIFont.systemFont(ofSize: 15)
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView = UIImageView()
        rightArrowImageView?.image = UIImage(named: "disclosure")
        rightArrowImageView?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel = UILabel()
        titleLabel?.text = "Priority"
        titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        titleLabel?.textColor = .systemGray
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        // Add icon and label to the view
        addSubview(iconImageView!)
        addSubview(nameLabel!)
        addSubview(rightArrowImageView!)
        addSubview(titleLabel!)
        
        // Adjust constraint for icon
        //iconImageView?.backgroundColor = .orange
        iconImageView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        
        // Adjust constraint for name label
        //nameLabel?.backgroundColor = .blue
        nameLabel?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel?.leadingAnchor.constraint(equalTo: iconImageView!.trailingAnchor, constant: 8.0).isActive = true
        nameLabel?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //nameLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        
        // Adjust constraints for right arrow image view
        //rightArrowImageView?.backgroundColor = .green
        rightArrowImageView?.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        rightArrowImageView?.widthAnchor.constraint(equalToConstant: 8.0).isActive = true
        rightArrowImageView?.leadingAnchor.constraint(equalTo: nameLabel!.trailingAnchor, constant: 8.0).isActive = true
        rightArrowImageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        rightArrowImageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Add constraints for title label
        titleLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        titleLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8.0).isActive = true
        
        layoutIfNeeded()
        
    }
    
    private func setUpGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(priorityRowPressed(tapGesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func priorityRowPressed(tapGesture: UITapGestureRecognizer){
        delegate?.didSelectPriority()
    }
}
