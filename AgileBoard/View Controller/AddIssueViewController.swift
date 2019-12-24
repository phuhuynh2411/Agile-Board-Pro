//
//  AddIssueViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/27/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class AddIssueViewController: UIViewController {

    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var typeImageView: CircleImageView!
    @IBOutlet weak var summaryTextView: KMPlaceholderTextView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    
    /// current project
    var project: Project?
    
    /// Selected Issue Type
    var selectedIssueType: IssueType?
    
    var delegate: IssueDetailDelegate?
    
    var keyboardHeight: CGFloat?
    
    var selectedPriority: Priority?
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        updateUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    override func viewDidLayoutSubviews() {
        //setUpView()
    }
    
    func setUpView() {
        // Create default priority
        selectedPriority = PriorityController.shared.default()
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        
        let status = StatusController.shared.status(name: "TO DO")
        let issue = Issue()
        issue.summary = summaryTextView.text
        issue.status = status
        issue.type = selectedIssueType
        
        let projectController = ProjectController()
        projectController.add(issue: issue, to: project!)
        
        delegate?.didAddIssue(with: issue)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func showMoreButtonPressed(_ sender: UIButton) {
        print("Show more button pressed")
        
        let priorityView = PriorityRowView(priority: selectedPriority)
        priorityView.delegate = self
       //  priorityView.priority = selectedPriority
        
        stackView.addArrangedSubview(priorityView)
       // self.stackView.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
            let selectIssueTypeTableViewController = navigationController.topViewController as! IssueTypeTableViewController
            
            selectIssueTypeTableViewController.selectedIssueType = selectedIssueType
            selectIssueTypeTableViewController.delegate = self
        }
        
        if segue.identifier == Identifier.SelectPrioritySegue {
            let priorityTableController = segue.destination as! PriorityTableViewController
            priorityTableController.selectedPriority = selectedPriority
        }
        
    }
    
}

// MARK: - UI TextView Delegate

extension AddIssueViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        // Dismiss the keyboard when pressing on the return key
        // Only apply for the summary field
        if text == "\n", textView.tag == 1 {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
       updateUI()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        scrollViewBottom.constant = keyboardHeight!
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollViewBottom.constant = 0
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

extension AddIssueViewController: IssueTypeTableViewDelegate {
    
    func didSelectIssueType(issueType: IssueType) {
        self.selectedIssueType = issueType
                
        updateUI()
    }
}

// MARK: - Priority View Delegate

extension AddIssueViewController: PriorityViewDelegate {
    
    func didSelectPriority() {
        performSegue(withIdentifier: Identifier.SelectPrioritySegue, sender: self)
    }
    
}
