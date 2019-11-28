//
//  AddIssueViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/27/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class AddIssueViewController: UIViewController {

    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    /// current project
    var project: Project?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Update UI
    
    func updateUI() {
        // Disable the create button by default
        createButton.isEnabled = false
        
        // Update project name
        projectTextField.text = project?.name
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
    
}

// MARK: - SelectProjectProtocol

extension AddIssueViewController: SelectProjectProtocol {
    
    func didSelectdProject(project: Project?) {
        self.project = project
        
        // Reload the UI
        updateUI()
    }
    
}

