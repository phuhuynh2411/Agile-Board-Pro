//
//  StatusDetailViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/20/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftValidator
import NotificationBannerSwift

protocol StatusDetailDelegate {
    func didAddStatus(status: Status)
    func didModifyStatus(status: Status)
}

class StatusDetailViewController: UIViewController {

    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var errorLabel: UILabel!
    
    var colors: Results<Color>?
    
    var selectedColor: Color?
    var status: Status?
    var project: Project?
    
    var isModified = false
    
    let validator = Validator()
    
    var delegate: StatusDetailDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        colors = ColorController.shared.all()
        
        // Select first color
        selectFirstColor()
        
        // Set the status text view as the first responder
        statusTextField.becomeFirstResponder()
        
        // Clear error message
        errorLabel.text = ""
        // Disable the done button when the view is loaded
        doneButton.isEnabled = false
        
        // Register fields for validation
        registerForValidation()
        
        // Rename Done button to add if selected color is empty
        // User adds a new color
        if selectedColor == nil {
            navigationItem.rightBarButtonItem?.title = "Add"
        }
    }
    
    private func updateView(components: [ViewCompoments] = [], markAsModified: Bool = false) {
        // Mark as modifed
        isModified = isModified ? isModified : markAsModified
    }
    
    private func selectFirstColor() {
        // Select the first color by default
        selectedColor = colors?.first
        
        let firstIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .top)
    }
    
    /**
     If status is nil, user is adding a new status; otherwise modifying the status
     */
    private func isNew()->Bool {
        return status == nil ? true : false
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        guard isModified, let statusName = statusTextField.text, let color = selectedColor else { return }
        
        let status = Status()
        status.color = color
        status.name = statusName
        // User is adding new status
        if isNew(){
            delegate?.didAddStatus(status: status)
        }
        else { // Modifying status
            delegate?.didModifyStatus(status: status)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        updateView(markAsModified: true)
        // Validate
        validator.validate(self)
    }
    
    
    // MARK: - Validations
    
    private func registerForValidation() {
        if let project = project {
            validator.registerField(statusTextField, errorLabel: errorLabel, rules: [RequiredRule(), StatusRule(project: project)])
        }
    }

    enum ViewCompoments {
        case collectionView
        case textField
    }
}

// MARK: - UICollectionView Datasource

extension StatusDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        
        let color = colors?[indexPath.row]
        
        if let hexColor = color?.hexColor {
            cell.colorImageView.backgroundColor = UIColor(hexString: hexColor)
        }
        
        if color?.id == selectedColor?.id {
            cell.addSubview(highlightView(for: cell, at: indexPath))
        }
        else {
            removeHighlightView(for: cell)
        }
        
        return cell
    }
    
    
}

// MARK: - UICollectionView Delegate

extension StatusDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors?[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.addSubview(highlightView(for: cell, at: indexPath))
            view.layoutIfNeeded()
        }
        
        updateView(markAsModified: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            removeHighlightView(for: cell)
        }
    }
    
    private func highlightView(for cell: UICollectionViewCell, at indexPath: IndexPath) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.tag = 1
        
        cell.addSubview(view)
        
        view.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        return view
    }
    
    private func removeHighlightView(for cell: UICollectionViewCell) {
        for view in cell.subviews {
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
    }
}

extension StatusDetailViewController: ValidationDelegate {
    func validationSuccessful() {
        doneButton.isEnabled = isModified
        
        errorLabel.text = ""
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        doneButton.isEnabled = false
        
        for (_, error) in errors {
            error.errorLabel?.text = error.errorMessage
        }
    }
}
