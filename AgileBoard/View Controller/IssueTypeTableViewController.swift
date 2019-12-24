//
//  SelectIssueTypeTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/28/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol IssueTypeTableViewDelegate {
    func didSelectIssueType(issueType: IssueType)
}

class IssueTypeTableViewController: UITableViewController {
    
    var issueTypes: List<IssueType>?
    var selectedIssueType: IssueType?
    
    var delegate: IssueTypeTableViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove extra seperators
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IB Actions
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return issueTypes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IssueTypeTableViewCell
        let issueType = issueTypes?[indexPath.row]
        cell.nameLabel.text = issueType?.name
        cell.descriptionLabel.text = issueType?.typeDescription
        
        if selectedIssueType?.id == issueType?.id {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        if let imageName = issueType?.imageName {
            cell.typeImageView.image = UIImage(named: imageName)
        }

        return cell
    }
    
}

// MARK: - Table View Delegate

extension IssueTypeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let issueType = issueTypes?[indexPath.row] else { return }
        
        delegate?.didSelectIssueType(issueType: issueType)
        
        dismiss(animated: true, completion: nil)
    }
}
