//
//  PriorityTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectPriorityDelegate {
    func didSelectPriority(priority: Priority)
}

class PriorityTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var priorityList: Results<Priority>?
    var selectedPriority: Priority?
    var delegate: SelectPriorityDelegate?

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        // Load all priorities
        priorityList = PriorityController.shared.all()
        
        // Remove extra seperators
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = 60
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priorityList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PriorityTableViewCell
        let priority = priorityList?[indexPath.row]
        cell.priorityNameLabel.text = priority?.name
        if let imageName = priority?.imageName {
             cell.iconImageView.image = UIImage(named: imageName)
        }
        
        
        // Show selected priority
        if priority?.id == selectedPriority?.id {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - UI Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPriority = priorityList?[indexPath.row]
        
        delegate?.didSelectPriority(priority: selectedPriority!)
        navigationController?.popViewController(animated: true)
    }
    
}