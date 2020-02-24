//
//  EditBoardNameViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol EditBoardNameDelegate {
    func didModifyName(board: Board)
}

class EditBoardNameViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    var board: Board?
    var delegate: EditBoardNameDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = board?.name {
            nameTextField.text = name
            nameTextField.becomeFirstResponder()
        }
        
        saveButton.isEnabled = false
        
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let name = nameTextField.text, let board = board{
            board.write({
                board.name = name
            }, completion: nil)
            delegate?.didModifyName(board: board)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
}
