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
    func didAdd(_ status: Status)
    func didModify(_ status: Status)
}

extension StatusDetailDelegate {
    func didAdd(_ status: Status) { return }
    func didModify(_ status: Status) { return }
}

class StatusDetailViewController: UIViewController {

    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var doneSwitch: UISwitch!
    
    var colors: Results<Color>?
    
    var selectedColor: Color?
    /// required when modifying status
    var status: Status?
    /// required when modifying status
    var project: Project?
    
    var userModifiedData = false
    
    let validator = Validator()
    
    var delegate: StatusDetailDelegate?
    
    let realm = AppDataController.shared.realm
    
    //var pageNumber: CGFloat = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        colors = realm?.objects(Color.self)
        
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
        if isNew {
            navigationItem.rightBarButtonItem?.title = "Create"
            // Select first color
            selectFirstColor()
        }else {
            navigationItem.rightBarButtonItem?.title = "Done"
            
            // Load status name if user is modifying an existing status
            if let status = status {
                statusTextField.text = status.name
                selectedColor = status.color
                doneSwitch.isOn = status.markedAsDone
            }
            
            let predicate = NSPredicate(format: "id == %@", status?.color?.id ?? "" )
            if let colorIndex = colors?.index(matching: predicate) {
                let indexPath = IndexPath(row: colorIndex, section: 0)
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
        
    }
    
    private func updateView(components: [ViewCompoments] = [], markAsModified: Bool = false) {
        // Mark as modifed
        userModifiedData = userModifiedData ? userModifiedData : markAsModified
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
    private var isNew: Bool {
        return status == nil ? true : false
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        guard userModifiedData, let statusName = statusTextField.text, let color = selectedColor else { return }
        
        let newStatus           = Status()
        newStatus.color         = color
        newStatus.name          = statusName
        newStatus.markedAsDone  = doneSwitch.isOn
        
        if isNew { dismiss(animated: true, completion: { self.delegate?.didAdd(newStatus) })
            return
        }
        // Modify status
        guard let status = self.status else { return }
        do {
            try status.write {
                status.name = statusName
                status.color = color
                status.markedAsDone = doneSwitch.isOn
            }
        } catch { print(error) }

        dismiss(animated: true, completion: { self.delegate?.didModify(status) })
    }
    
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        updateView(markAsModified: true)
        validator.validate(self)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        updateView(markAsModified: true)
        validator.validate(self)
    }
    
    
    // MARK: - Validations
    
    private func registerForValidation() {
        if let project = project {
            var rules: [Rule] = [RequiredRule()]
            let statusRule = StatusRule(project: project)
            if !isNew {
                statusRule.status = status
            }
            rules.append(statusRule)
            
            validator.registerField(statusTextField, errorLabel: errorLabel, rules: rules)
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
        validator.validate(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            removeHighlightView(for: cell)
        }
    }
    
    private func highlightView(for cell: UICollectionViewCell, at indexPath: IndexPath) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
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
    
    // MARK: UIScrollView Delegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let pageWidth = scrollView.frame.size.width
        var pageNumber: Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth = layout.itemSize.width
        let spacing = layout.minimumLineSpacing
        let numberOfCells = Int(pageWidth/(cellWidth + spacing))
        
        let totalCellWidth = CGFloat(numberOfCells) * cellWidth
        let totalSpacing = CGFloat(numberOfCells ) * spacing

        // Scroll left
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
            pageNumber -= 1
        }
        // Scroll right
        else {
            pageNumber += 1
        }
        let newX = CGFloat(pageNumber) * (totalSpacing + totalCellWidth)
        
        let rect = CGRect(x: newX, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
}

extension StatusDetailViewController: ValidationDelegate {
    func validationSuccessful() {
        doneButton.isEnabled = userModifiedData
        
        errorLabel.text = ""
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        doneButton.isEnabled = false
        
        for (_, error) in errors {
            error.errorLabel?.text = error.errorMessage
        }
    }
}
