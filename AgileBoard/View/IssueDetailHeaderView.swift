//
//  AddIssueHeaderView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/4/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class IssueDetailHeaderView: UIView {

    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var summaryTextView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var projectButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    /// Show or hide the isuse type icon
    var showTypeIcon: Bool = false {
        willSet {
            let widthConstraint = typeImageView.constraints.first { $0.identifier == "imageWidthConstraint" }!
            if newValue {
                widthConstraint.constant = 20
            }
            else {
                widthConstraint.constant = 0
            }
        }
    }
    
    var showMoreField: Bool = false {
        willSet{
            let buttonTitle = newValue ? "Show less fields" : "Show more fields"
            showMoreButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    override func draw(_ rect: CGRect) {
        showMoreButton.addTarget(self, action: #selector(showMoreButtonPressed(sender:)), for: .touchUpInside)
        
        // Remove all padding from UITextView
        let padding = summaryTextView.textContainer.lineFragmentPadding
        summaryTextView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    func viewHeight() -> CGFloat {
        let numberOfViews = self.stackView.arrangedSubviews.count
        let stackViewHeight = CGFloat(numberOfViews - 1 ) * stackView.spacing
        
        let height = topStackView.frame.height + summaryTextView.frame.height +
            descriptionTextView.frame.height + stackViewHeight + showMoreButton.frame.height
        
        return height
    }
    
    @objc func showMoreButtonPressed(sender: UIButton) {
        showMoreField = !showMoreField
    }
}
