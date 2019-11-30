//
//  AddProjectTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol AddProjectDelegate {
    func didAddProject(project: Project?)
}

class AddProjectTableViewController: UITableViewController {
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    @IBOutlet weak var projectIconImageView: RoundImageView!
    
    @IBOutlet weak var keyTextField: UITextField!
    
    @IBOutlet weak var projectDescriptionTextView: KMPlaceholderTextView!
    
    @IBOutlet weak var descriptionCell: UITableViewCell!
    
    @IBOutlet weak var createOrSaveButton: UIBarButtonItem!
    
    
    var tableViewOriginalHeight: CGFloat?
    var textViewOriginalHeight: CGFloat?
    
    var project: Project?
    var selectedIcon: ProjectIcon?
    var delegate: AddProjectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Close keyboard
        projectNameTextField.resignFirstResponder()
        
        // Pre-populate data for new project
        if project == nil {
            projectNameTextField.text = "New Project"
            projectIconImageView.image = UIImage(named: "default_project_icon")
            selectedIcon = ProjectIconController.icon(name: "default_project_icon")
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.title = "New Project"
        }
        // Load existing project data
        else {
            projectNameTextField.text = project?.name
            keyTextField.text = project?.key
            projectDescriptionTextView.text = project?.projectDescription
            selectedIcon = project?.icon
            
            // Rename the right button bar button and disable it
            navigationItem.rightBarButtonItem?.title = "Save"
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.title = "Edit Project"
        }
        
        updateUI()
                
    }
    
    override func viewDidLayoutSubviews() {
       tableViewContentSize()
    }
    
    func updateUI() {
        
        if let projectIcon = selectedIcon {
            projectIconImageView.image = UIImage(named: projectIcon.name)
        }
    }
    
    func shouldEnableCreateOrSaveButton() {
        
        if !projectNameTextField.text!.isEmpty && !keyTextField.text!.isEmpty {
            createOrSaveButton.isEnabled = true
        }
        else {
            createOrSaveButton.isEnabled = false
        }
    }
    
    /**
     Recalculate the table view content height based on the text view
     */
    func tableViewContentSize() {
        
        // Get the table view orininal height after loading the view
        if tableViewOriginalHeight == nil {
        tableViewOriginalHeight = tableView.contentSize.height
            textViewOriginalHeight = projectDescriptionTextView.frame.size.height
        }
        
        // Update the the height for description cell and table view content size's height.
        descriptionCell.frame.size = CGSize(width: descriptionCell.frame.size.width, height: sizeOfTextView().height)
        tableView.contentSize.height = tableViewOriginalHeight! + sizeOfTextView().height
    
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func projectNameDidChange(_ sender: UITextField) {
        shouldEnableCreateOrSaveButton()
    }
    
    @IBAction func projectKeyDidChange(_ sender: UITextField) {
        shouldEnableCreateOrSaveButton()
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        
        // If user is creating a new project
        if project == nil {
            project = Project()
            project?.name = projectNameTextField.text!
            project?.icon = selectedIcon
            project?.projectDescription = projectDescriptionTextView.text
            project?.key = keyTextField.text!
            
            ProjectController.add(project: project!)
        }
        // User is updating an existing project
        else {
            let modifiedProject = Project()
            modifiedProject.name = projectNameTextField.text!
            modifiedProject.icon = selectedIcon
            modifiedProject.projectDescription = projectDescriptionTextView.text
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
    
    func sizeOfTextView() -> CGSize {
        
        let fixedWidth = projectDescriptionTextView.frame.size.width
        let newSize = projectDescriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        return CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + 12)
                
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Detects changes and enable the create or save button
        shouldEnableCreateOrSaveButton()
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        descriptionCell.frame.size = CGSize(width: descriptionCell.frame.size.width, height: sizeOfTextView().height)

        tableView.contentSize.height = tableViewOriginalHeight! + sizeOfTextView().height - textViewOriginalHeight!
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
       updateUI()
    }
    
}

// MARK: - Select Icon Delegate

extension AddProjectTableViewController: SelectIconDelegate {
    func didSelectIcon(icon: ProjectIcon?) {
        selectedIcon = icon
        
        updateUI()
        
        shouldEnableCreateOrSaveButton()
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

        // PROJECT NAME
        // make sure it is less than or equal 80 characters
        if textField.tag == 1 {
            return updatedText.count <= 80
        }
        
        // PROJECT KEY
        // make sure it is less than or equal 5 characters
        return updatedText.count <= 5
    }

}
