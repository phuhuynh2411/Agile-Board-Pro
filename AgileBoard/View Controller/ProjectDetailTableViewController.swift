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
import NotificationBannerSwift

protocol ProjectDetailTableViewDelegate {
    func didAdd(_ project: Project) -> Void
    func didEdit(_ project: Project) -> Void
}

extension ProjectDetailTableViewDelegate {
    func didAdd(project: Project) -> Void { return }
    func didEdit(project: Project) -> Void { return }
}

class ProjectDetailTableViewController: UITableViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var iconImageView: RoundImageView!
    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var descriptionTextView: KMPlaceholderTextView!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: Properties
    
    private var tabbleViewInitialHeight: CGFloat?
    private var textViewInitalHeight: CGFloat?
    
    var project: Project?
    var selectedIcon: ProjectIcon?
    var delegate: ProjectDetailTableViewDelegate?
    
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
        
        viewFitsTextView()
        
    }
    
    private func setUpView() {
        
        // Change the navigation item's title
        navigationItem.title = isNew ? "New Project" : "Edit Project"
        // Change the right button bar text
        navigationItem.rightBarButtonItem?.title = isNew ? "Create" : "Done"
        
        // Load project data
        nameTextField.text = project?.name
        keyTextField.text = project?.key
        descriptionTextView.text = project?.projectDescription
        self.selectedIcon = isNew ? .standard : project?.icon
        
        // Register fields for validation
        registerFieldsForValidation()
        
        // Update view
        self.updateView()

    }
    
    private func updateView() {
        
        // Display the project's icon
        if let projectIcon = selectedIcon {
            iconImageView.image = UIImage(named: projectIcon.name)
        }
        
        doneButton.isEnabled = validated
    }
    
    // MARK: Helper methods
    
    /**
     Recalculate the table view content height based on the text view
     */
    private func viewFitsTextView() {
        // Adjust the text view's height to fit its content
        fitTextViewSize(textView: descriptionTextView)
        // Adjust the table view cell to fit the text view
        descriptionCell.frame.size = CGSize(width: descriptionCell.frame.size.width, height: descriptionTextView.frame.height + CGFloat(12))
        // Adjust the table view content size to fit the cell
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
    private var isNew: Bool {
        return project == nil ? true : false
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        if validated && !isNew { self.delegate?.didEdit( self.project!) }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameDidChange(_ sender: UITextField) {
        validator.validate(self)
    }
    
    @IBAction func keyDidChange(_ sender: UITextField) {
        validator.validate(self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        // Make sure the user's input is validated
        guard validated else { return }
        
        guard let name      = nameTextField.text else { return }
        guard let key       = keyTextField.text else { return }
        let description     = descriptionTextView.text ?? ""
        
        if isNew {
            let project = Project(name: name, description: description, key: key, icon: self.selectedIcon)
            self.delegate?.didAdd(project)
        }
        else {
            do {
                try self.project?.write {
                    project?.name = name
                    project?.key = key
                    project?.projectDescription = description
                    project?.icon = self.selectedIcon
                }
            } catch { print(error) }
            self.delegate?.didEdit( self.project! )
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapedOnIconImageView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Identifier.SelectIconSegue, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Identifier.SelectIconSegue {
            let vc = segue.destination as! IconCollectionViewController
            vc.selectedIcon = selectedIcon
            vc.delegate = self
        }
        
    }

}

// MARK: - UI TextView Delegate

extension ProjectDetailTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        viewFitsTextView()
        // Validate the data and enable the Save/Create button
        validator.validate(self)
    }

}

// MARK: - Select Icon Delegate

extension ProjectDetailTableViewController: IconCollectionViewDelegate {
    
    func didSelect(_ icon: ProjectIcon?) {
        selectedIcon = icon
        validator.validate(self)
    }
    
}

// MARK: - UI TextField Delegate

extension ProjectDetailTableViewController: UITextFieldDelegate {
    
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

extension ProjectDetailTableViewController: ValidationDelegate {
    
    // MARK: Validation successful
    
    func validationSuccessful() {
        validated = true
        updateView()
    }
    
    // MARK: Validation failed
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        validated = false
        updateView()
    }
    
    // MARK: Helper Methods
    private func registerFieldsForValidation() {
        
        // The project name is required and its maximum characters is 30.
        let nameRules: [Rule] = [RequiredRule(), MaxLengthRule(length: 30)]
        validator.registerField(nameTextField, rules: nameRules)
        
        // The key is required and limited 5 characters.
        let keyRules: [Rule] = [RequiredRule(), MaxLengthRule(length: 5), ProjectKeyRule(project: self.project)]
        validator.registerField(keyTextField, rules: keyRules)
        
    }
    
}
