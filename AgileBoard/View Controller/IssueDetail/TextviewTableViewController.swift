//
//  TextviewTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import SwiftValidator

protocol TextViewTableViewDelegate {
    func issueDidChange(issue: Issue)
}

class TextviewTableViewController: UITableViewController {
    
    // MARK: IB Outlets
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: Properties
    
    var headerView: IssueDetailHeaderView!
    var issue: Issue?
    var isModified = false
    
    var delegate: TextViewTableViewDelegate?
    
    var validator = Validator()
    
    var selectedTextViewTag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        updateView(components: [.summary, .description, .header])
    }
    
    func setUpView() {
        // Set up table view header
        headerView = .fromNib()
        headerView.viewFor(.editContent)
        headerView.textViewDelagate = self
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: headerView.height))
               tableHeaderView.addSubview(headerView)
        tableView.tableHeaderView = tableHeaderView
        
        // Remvove tableview's extra separators
        tableView.tableFooterView = UIView()
        
        // Register for validations
        registerForValidation()
        
        // Disable the done button by default
        doneButton.isEnabled = false
        
        if selectedTextViewTag == 0 {
            headerView.summaryTextView.becomeFirstResponder()
        } else {
            headerView.descriptionTextView.becomeFirstResponder()
        }
    }
    
    private func updateView(components: [ViewComponent], markAsModified: Bool = false){
        // Update summary
        if components.contains(.summary) {
            headerView.summaryTextView.text = issue?.summary
        }
        // Update description
        if components.contains(.description) {
            headerView.descriptionTextView.text = issue?.issueDescription
        }
        // Update header
        if components.contains(.header) {
            headerFitsHeightContent()
        }
        
        // Update modifed status
        isModified = isModified ? isModified : markAsModified
        
        // Validate user's input
        validator.validate(self)
    }
    
    // MARK: - Helper methods
    /**
     Adjusts the table view header to fit the text view height
     */
    private func headerFitsHeightContent() {
        let size = tableView.frame.size
        tableView.tableHeaderView?.frame.size = CGSize(width: size.width, height: headerView.height)
        tableView.reloadData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if let summary = headerView.summaryTextView.text,
            let description = headerView.descriptionTextView.text,
            let issue = issue {
            
            //IssueController.shared.update(summary: summary, description: description, to: issue)
            issue.write({
                issue.summary = summary
                issue.issueDescription = description
            }) { (error) in
                if let error = error {
                    print(error)
                }
            }
            delegate?.issueDidChange(issue: issue)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - UITextView Delegate

extension TextviewTableViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Dismiss the keyboard when pressing on the return key
        // Only apply for the summary field
        if text == "\n", textView == headerView?.summaryTextView {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateView(components: [.header], markAsModified: true)
    }
    
}

// MARK: - View Components
extension TextviewTableViewController {
    private enum ViewComponent {
        case header
        case summary
        case description
    }
}

// MARK: - Validations

extension TextviewTableViewController: ValidationDelegate {
    func registerForValidation() {
        validator.registerField(headerView.summaryTextView, rules: [RequiredRule()])
    }
    
    func validationSuccessful() {
        doneButton.isEnabled = isModified
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
         doneButton.isEnabled = false
    }
}
