//
//  BoardDetailViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftValidator

protocol BoardDetailViewControllerDelegate {
    func didAddBoard(board: Board)
    func didModifyBoard(board: Board)
}

class BoardDetailViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    var titleView: BoardTextFieldTitleView!
    
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    @IBOutlet weak var columnCollectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var statusCollectionController: BoardDetailStatusViewController?
    var columnCollectionController: BoardDetailColumnViewController?
    
    @IBOutlet weak var stackView: UIStackView!
    
    var statuses: List<Status>?
    var columns: List<Column>?
    
    // A selected status used when modifying status
    var selectedStatus: Status?
    
    var project: Project?
    
    var validator = Validator()
    
    var delegate: BoardDetailViewControllerDelegate?
    
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize title view
        titleView = .fromNib()
        navigationItem.titleView = titleView
        titleView?.nameTextField.delegate = self
        titleView?.nameTextField.returnKeyType = .done
        
        // Disable the create button when the view is loaded
        createButton.isEnabled = false
        
        // Set up status view controller
        initStatusCollectionView()
        
        // Set up column view controller
        initColumnCollectionView()
        
        // Register fields for validation
        validator.registerField(titleView.nameTextField, errorLabel: errorLabel, rules: [RequiredRule()])
        
        // Clears the error label after the view loaded.
        errorLabel.text = ""
        
        // Observes for text field changed
        titleView.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Dismisses the keyboard if collection views tapped.
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGesture1.cancelsTouchesInView = false
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGesture2.cancelsTouchesInView = false
        statusCollectionView.addGestureRecognizer(tapGesture1)
        columnCollectionView.addGestureRecognizer(tapGesture2)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        columnCollectionView.collectionViewLayout.invalidateLayout()
        statusCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // Dismiss the keyboard when tapping on anywhere on the layout.
        // view.endEditing(true)
        titleView?.nameTextField.resignFirstResponder()
    }
    
    // MARK: - Helper methods
    
    private func initStatusCollectionView() {
        
        // Make the collection view round
        statusCollectionView.layer.cornerRadius = 5.0
        statusCollectionView.clipsToBounds = true
        
        // Status Collection View
        statusCollectionController = BoardDetailStatusViewController()
        statusCollectionController?.statuses = statuses
        
        // Add data source and delegate
        statusCollectionView.delegate = statusCollectionController
        statusCollectionView.dataSource = statusCollectionController
        let layout = statusCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        
        // Enable drag and set up drag delegate
        statusCollectionView.dragInteractionEnabled = true
        statusCollectionView.dragDelegate = statusCollectionController
        statusCollectionView.dropDelegate = statusCollectionController

    }
    
    private func initColumnCollectionView() {
        // Make the collection view round
        columnCollectionView.layer.cornerRadius = 5.0
        columnCollectionView.clipsToBounds = true
        
        // Column Collection View
        columnCollectionController = BoardDetailColumnViewController()
        columnCollectionController?.columns = columns
        
        // Add data source and delegate
        columnCollectionView.delegate = columnCollectionController
        columnCollectionView.dataSource = columnCollectionController
        
        // Enable drag and drop
        columnCollectionView.dragInteractionEnabled = true
        columnCollectionView.dragDelegate = columnCollectionController
        columnCollectionView.dropDelegate = columnCollectionController
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        //view.endEditing(true)
        titleView.nameTextField.resignFirstResponder()
        print("dismiss the keyboard")
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        if let name = titleView.nameTextField.text, let columns = columns {
            let board = Board()
            board.name = name
            board.columns.append(objectsIn: columns)
            
            delegate?.didAddBoard(board: board)
            dismiss(animated: true, completion: nil)
        }
       
    }
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddStatusSegue" {
            let navigationController = segue.destination as! UINavigationController
            let statusDetailViewController = navigationController.topViewController as! StatusDetailViewController
            statusDetailViewController.delegate = self
        }
        else if segue.identifier == "EditStatusSegue" {
            let navigationController = segue.destination as! UINavigationController
            let statusDetailViewController = navigationController.topViewController as! StatusDetailViewController
            statusDetailViewController.delegate = self
            statusDetailViewController.status = selectedStatus
            statusDetailViewController.project = project
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension BoardDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        print("Text fiedl did change")
        validator.validate(self)
    }
}

// MARK: - StatusDetailDelegate

extension BoardDetailViewController: StatusDetailDelegate {
    
    func didAddStatus(status: Status) {
        if let project = project {
            statuses?.append(status)
            ProjectController.shared.add(status: status, to: project)
            statusCollectionView.reloadData()
        }
        
    }
    
    func didModifyStatus(status: Status) {
        if let selectedStatus = selectedStatus{
            StatusController.shared.update(status: selectedStatus, toStatus: status)
            statusCollectionView.reloadData()
        }
    }
}


// MARK: - Validations

extension BoardDetailViewController: ValidationDelegate {
    
    func validationSuccessful() {
        // Enable the create button
        createButton.isEnabled = true
        // Clears previous error message
        errorLabel.text = ""
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // Disable the create button
        createButton.isEnabled = false
        for (_, error) in errors {
            errorLabel.text = error.errorMessage
        }
    }
}