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
    
    // Parent Views
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var issueTypeAndIssueIDView: UIView!
    @IBOutlet weak var typeAndProjectStackView: UIStackView!
    
    @IBOutlet weak var summaryTextView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    
    // Controls and views for add
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var projectButton: UIButton!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var typeImageView: UIImageView!
    
    // Controls and views for edit
    @IBOutlet weak var typeImageView2: UIImageView!
    @IBOutlet weak var issueIDLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    // Separators
    @IBOutlet weak var middleSeparatorView: UIView!
    @IBOutlet weak var rowSeparatorView: UIView!
    
    // Text view delegate
    var textViewDelagate: UITextViewDelegate? {
        willSet{
            summaryTextView.delegate = newValue
            descriptionTextView.delegate = newValue
        }
    }
    
    override func awakeFromNib() {
        
        showMoreButton.addTarget(self, action: #selector(showMoreButtonPressed(sender:)), for: .touchUpInside)
        
        // Remove left and right padding from UITextView
        let padding = summaryTextView.textContainer.lineFragmentPadding
        summaryTextView.textContainerInset = UIEdgeInsets(top: 5, left: -padding, bottom: 5, right: -padding)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 5, left: -padding, bottom: 5, right: -padding)
        
        // Style the status button
        statusButton.backgroundColor = .blue
        statusButton.layer.cornerRadius = 13
        statusButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 26)
        
    }
    
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
    
    var height: CGFloat{
        // Lays out the subviews immediately, if layout updates are pending.
        layoutIfNeeded()
        return backgroundStackView.frame.height
    }
    
    @objc func showMoreButtonPressed(sender: UIButton) {
        showMoreField = !showMoreField
    }
    
    override func didMoveToSuperview() {
        guard let supperView = self.superview else { return }
        trailingAnchor.constraint(equalTo: supperView.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: supperView.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: supperView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: supperView.bottomAnchor).isActive = true
    }
    
    func viewFor(_ component: ViewComponent) {
        if component == .add {
           keepViewsForAdd()
        }
        else if component == .edit {
           keepViewsForEdit()
        }
        else if component == .editContent {
            keepViewsForEditContent()
        }
        layoutIfNeeded()
    }
    
    /**
     Keeps views for add mode and removes all other views.
     */
    private func keepViewsForAdd() {
        statusView.removeFromSuperview()
        issueTypeAndIssueIDView.removeFromSuperview()
    }
    
    /**
     Keeps views for edit mode and removes all other views.
     */
    private func keepViewsForEdit() {
        typeAndProjectStackView.removeFromSuperview()
        middleSeparatorView.removeFromSuperview()
        rowSeparatorView.removeFromSuperview()
        showMoreButton.removeFromSuperview()
    }
    
    /**
     Keeps the summary and description text view only and removes all other views
     */
    private func keepViewsForEditContent() {
        for view in backgroundStackView.subviews {
            if !(view == summaryTextView || view == descriptionTextView) {
                view.removeFromSuperview()
            }
        }
        middleSeparatorView.removeFromSuperview()
        rowSeparatorView.removeFromSuperview()
        layoutIfNeeded()
    }
    
}

extension IssueDetailHeaderView {
    enum ViewComponent {
        case edit
        case add
        case editContent
    }
}
