//
//  StatusTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol StatusDelegate {
    func didSelectStatus(status: Status)
}

class StatusTableViewController: UITableViewController {
    
    var statuses: List<Status>?
    var selectedStatus: Status?
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
    }
    
    // MARK: - UITableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell") as! StatusTableViewCell
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
        if let selectedStatus = selectedStatus {
            StatusController.shared.update(status: status, toStatus: selectedStatus)
        }
    }
}

// MARK: - Segue Identifiers
extension StatusTableViewController {
    struct SegueIdentifier {
        static let statusDetail = "StatusDetailControllerSegue"
    }
    typealias S = SegueIdentifier
}
