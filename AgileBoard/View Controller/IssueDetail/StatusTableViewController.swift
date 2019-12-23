//
//  StatusTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

protocol StatusDelegate {
    func didSelectStatus(status: Status)
}

class StatusTableViewController: UITableViewController {
    
    var statuses: List<Status>?
    var selectedStatus: Status?
    var currentStatus: Status?
    var project: Project?
    
    // Delegate
    var delegate: StatusDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        
        let label = UILabel()
        //label.textColor = UIColor.white
        label.text = "Transition issue"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        // Remove extra separators
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IB Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: S.statusDetail, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == S.statusDetail {
            let nav = segue.destination as! UINavigationController
            let statusDetailViewController = nav.topViewController as! StatusDetailViewController
            
            statusDetailViewController.delegate = self
            statusDetailViewController.project  = project
        }
        else if segue.identifier == S.editStatusDetail {
            let nav = segue.destination as! UINavigationController
            let statusDetailViewController = nav.topViewController as! StatusDetailViewController
            
            statusDetailViewController.delegate = self
            statusDetailViewController.project  = project
            statusDetailViewController.status = currentStatus
        }
    }
    
    // MARK: - UITableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell") as! StatusTableViewCell
        cell.delegate = self
        
        let status = statuses?[indexPath.row]
        cell.statusNameLabel.text = status?.name
        if let color = status?.color {
            cell.statusImageView.backgroundColor = UIColor(hexString: color.hexColor)
        }
       
        if selectedStatus?.id == status?.id {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let status = statuses?[indexPath.row]
        
        if let status = status {
            delegate?.didSelectStatus(status: status)
        }
        dismiss(animated: true, completion: nil)
    }

}

// MARK: Status Detail Delegate

extension StatusTableViewController: StatusDetailDelegate {
    func didAddStatus(status: Status) {
        if let project = project {
            StatusController.shared.add(status, to: project)
            tableView.reloadData()
        }
    }
    
    func didModifyStatus(status: Status) {
        if let currentStatus = currentStatus {
            StatusController.shared.update(status: currentStatus, toStatus: status)
            tableView.reloadData()
        }
    }
}

// MARK: - Segue Identifiers
extension StatusTableViewController {
    struct SegueIdentifier {
        static let statusDetail = "StatusDetailControllerSegue"
        static let editStatusDetail = "StatusDetailControllerEditSegue"
    }
    typealias S = SegueIdentifier
}

// MARK: - SwipeTableViewCellDelegate

extension StatusTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var action: SwipeAction!

        if orientation == .right {
            action = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // TODO: handle action by updating model with deletion
            }
        }
        else if orientation == .left {
            // Edit cell
            action = SwipeAction(style: .default, title: "Edit") { action, indexPath in
                self.currentStatus = self.statuses?[indexPath.row]
                self.performSegue(withIdentifier: S.editStatusDetail, sender: self)
            }
        }
        
        return [action]
    }
    
}
