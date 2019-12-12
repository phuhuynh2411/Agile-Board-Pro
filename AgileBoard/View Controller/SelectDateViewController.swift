//
//  SelectDateViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

protocol SelecteDateDelegate {
    /**
     Press the clear button on the navigation bar
     */
    func clearDate()
    /**
     User selected date on the date picker and pressed the done butotn
     */
    func didSelectDate(date: Date)
}

class SelectDateViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MAKR: Properites
    var delegate: SelecteDateDelegate?
    
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        if let date = selectedDate {
            datePicker.date = date
        }
    }

    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.clearDate()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.didSelectDate(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
}
