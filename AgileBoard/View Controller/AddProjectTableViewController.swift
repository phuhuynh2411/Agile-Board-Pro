//
//  AddProjectTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import SwiftValidator

protocol AddProjectDelegate {
    func didAddProject(project: Project?)
}

class AddProjectTableViewController: UITableViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameTextField: ProjectNameTextField!
    @IBOutlet weak var iconImageView: RoundImageView!
    @IBOutlet weak var keyTextField: ProjectKeyTextField!
    @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: Properties
    
    private var tabbleViewInitialHeight: CGFloat?
    private var textViewInitalHeight: CGFloat?
    
    var project: Project?
    var selectedIcon: ProjectIcon?
    var delegate: AddProjectDelegate?
    
    /// Validation
    let validator = Validator()
    /// Determine where the user's input is validated or not.
    var validated = false

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        
        if tabbleViewInitialHeight == nil {
            // Get table view's initial height
            tabbleViewInitialHeight = tableView.contentSize.height
            // Get text view's inital height
            textViewInitalHeight = descriptionTextView.frame.height
        }
        
        fitTableViewSize()
        
    }
    
    private func setUpView() {
        
        // Change the navigation item's title
        navigationItem.title = isEditing() ? "Edit Project" : "New Project"
        // Change the right button bar text
        navigationItem.rightBarButtonItem?.title = isEditing() ? "Save" : "Create"
        
        // Hide the done button by default
        doneButton.isEnabled = false
        
        // Load project data
        nameTextField.text = project?.name
        keyTextField.text = project?.key
        descriptionTextView.text = project?.projectDescription
        selectedIcon = isEditing() ? project?.icon : ProjectIconController.defaultIcon()
        
        // Load Icon
        loadIcon()
        
        // Register fields for validation
        registerFieldsForValidation()

    }
    
    private func updateView() {
        loadIcon()
    }
    
    // MARK: Helper methods
    
    private func loadIcon() {
        // Display the project's icon
        if let projectIcon = selectedIcon {
            iconImageView.image = UIImage(named: projectIcon.name)
        }
    }
    
    /**
     Recalculate the table view content height based on the text view
     */
    func fitTableViewSize() {
        
        fitTextViewSize(textView: descriptionTextView)
        
        descriptionCell.frame.size = CGSize(width: descriptionCell.frame.size.width, height: descriptionTextView.frame.height + CGFloat(12))
        
        tableView.contentSize.height = tabbleViewInitialHeight! + descriptionTextView.frame.height - textViewInitalHeight!
        
    }
    
    /**
     A best fitting size for text view
     */
    private func fitTextViewSize(textView: UITextView){
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        textView.frame.size =  CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
           
    /**
     - Returns: `true` if the project is exist, otherwise ``false`
     */
    private func isEditing() -> Bool {
        return project == nil ? false : true
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func projectNameDidChange(_ sender: UITextField) {
        validator.validate(self)
    }
    
    @IBAction func projectKeyDidChange(_ sender: UITextField) {
        validator.validate(self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        // Make sure the user's input is validated
        guard validated else { return }
        
        // If user is creating a new project
        if project == nil {
            project = Project()
            project?.name = nameTextField.text!
            project?.icon = selectedIcon
            project?.projectDescription = descriptionTextView.text
            project?.key = keyTextField.text!
            
            ProjectController.add(project: project!)
        }
            // User is updating an existing project
        else {
            let modifiedProject = Project()
            modifiedProject.name = nameTextField.text!
            modifiedProject.icon = selectedIcon
            modifiedProject.projectDescription = descriptionTextView.text
            modifiedProject.key = keyTextField.text!
            
            ProjectController.update(project: project!, by: modifiedProject)
        }
        delegate?.didAddProject(project: project)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tapedOnIconImageView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Identifier.SelectIconSegue, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Identifier.SelectIconSegue {
            let iconCollectionViewController = segue.destination as! IconCollectionViewController
            iconCollectionViewController.selectedIcon = selectedIcon
            iconCollectionViewController.delegate = self
        }
        
    }

}

// MARK: - UI TextView Delegate

extension AddProjectTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        fitTableViewSize()
    }

}

// MARK: - Select Icon Delegate

extension AddProjectTableViewController: SelectIconDelegate {
    
    func didSelectIcon(icon: ProjectIcon?) {
        selectedIcon = icon
        validator.validate(self)
        
        updateView()
    }
    
}

// MARK: - UI TextField Delegate

extension AddProjectTableViewController: UITextFieldDelegate {
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // Validate project's name
        if textField == nameTextField {
            return updatedText.count <= 30
        }
        // Validate project's key
        else if textField == keyTextField {
            return updatedText.count <= 5
        }
        
        return true
    }

}

// MARK: - Validator

extension AddProjectTableViewController: ValidationDelegate {
    
    // MARK: Validation successful
    
    func validationSuccessful() {
        doneButton.isEnabled = true
        validated = true
    }
    
    // MARK: Validation failed
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        doneButton.isEnabled = false
        validated = false
    }
    
    // MARK: Helper Methods
    private func registerFieldsForValidation() {
        
        // The project name is required and its maximum characters is 30.
        let nameRules: [Rule] = [RequiredRule(), MaxLengthRule(length: 30)]
        validator.registerField(nameTextField, rules: nameRules)
        
        // The key is required and limited 5 characters.
        let keyRules: [Rule] = [RequiredRule(), MaxLengthRule(length: 5)]
        validator.registerField(keyTextField, rules: keyRules)
        
    }
    
}
