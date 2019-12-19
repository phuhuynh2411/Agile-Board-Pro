//
//  StatusTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class StatusTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IB Actions
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
