//
//  AddIssueViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/27/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol AddIssueDelegate {
    func didAddIssue(with issue: Issue)
}

class AddIssueViewController: UIViewController {

    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    
    @IBOutlet weak var typeImageView: CircleImageView!
    
    @IBOutlet weak var summaryTextView: KMPlaceholderTextView!
    
    
    /// current project
    var project: Project?
    
    /// Selected Issue Type
    var selectedIssueType: IssueType?
    
    var delegate: AddIssueDelegate?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        
        let statusController = StatusController()
        let status = statusController.status(name: "TO DO")
        let issue = Issue()
        issue.summary = summaryTextView.text
        issue.status = status
        issue.type = selectedIssueType
        
        let projectController = ProjectController()
        projectController.add(issue: issue, to: project!)
        
        delegate?.didAddIssue(with: issue)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Update UI
    
    func updateUI() {
        // Disable the create button by default
        createButton.isEnabled = false
        
        // Update project name
        projectTextField.text = project?.name
        
        // Update issue type name
        typeTextField.text = selectedIssueType?.name
        
        // Update issue's icon
        if let imageName = selectedIssueType?.imageName {
            installTypeImageView(isInstalled: true)
            typeImageView.image = UIImage(named: imageName)
        }
        else {
            installTypeImageView(isInstalled: false)
        }
        
        // Enable or disable the create button
        shouldEnableCreateButton()
        
    }
    
    /**
     Install or uninstall issue's icon
     */
    func installTypeImageView(isInstalled: Bool) {
        
        let heightContraint = typeImageView.constraints.first { $0.identifier == "heightConstraint"}!
        let widthContraint = typeImageView.constraints.first{ $0.identifier == "widthConstraint" }!
        
        if isInstalled {
            heightContraint.constant = 30.0
            widthContraint.constant = 30.0
        }
        else {
            heightContraint.constant = 0
            widthContraint.constant = 0
        }
        
    }
    
    /**
     Check whether should enable the Create button or not
     */
    func shouldEnableCreateButton() {
        if project != nil, selectedIssueType != nil, !summaryTextView.text.isEmpty {
            createButton.isEnabled = true
        }
        else {
            createButton.isEnabled = false
        }
    }
    
    // MARK: - Tap gesture recognizer
    
    @IBAction func tapOnProjectView(sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: Identifier.SearchProjectSegue, sender: self)
        
    }
    
    @IBAction func tapOnTypeView(sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: Identifier.SelectIssueTypeSegue, sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the selected project to the Serach Project View Controller
        if segue.identifier == Identifier.SearchProjectSegue {
            let navigationController = segue.destination as! UINavigationController
            let searchProjectViewController = navigationController.topViewController as! SearchProjectViewController
            searchProjectViewController.selectedProject = project
            searchProjectViewController.delegate = self
        }
        
        if segue.identifier == Identifier.SelectIssueTypeSegue {
            let navigationController = segue.destination as! UINavigationController
            let selectIssueTypeTableViewController = navigationController.topViewController as! SelectIssueTypeTableViewController
            
            selectIssueTypeTableViewController.selectedIssueType = selectedIssueType
            selectIssueTypeTableViewController.delegate = self
        }
        
    }
    
}

// MARK: - UI TextView Delegate

extension AddIssueViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Dismiss the keyboard when pressing on the return key
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
       updateUI()
    }
    
}

// MARK: - SelectProjectProtocol

extension AddIssueViewController: SelectProjectDelegate {
    
    func didSelectdProject(project: Project?) {
        self.project = project
        
        // Reload the UI
        updateUI()
    }
    
}

// MARK: - SelectIssueType Delegate

extension AddIssueViewController: SelectIssueTypeDelegate {
    
    func didSelectIssueType(issueType: IssueType?) {
        self.selectedIssueType = issueType
                
        updateUI()
    }
}
