//
//  BoardTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class BoardTableViewController: UITableViewController {
    
    var boards: List<Board>?
    
    var selectedBoard: Board?
    
    var project: Project?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove table view's extra seperators
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IB Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("Pressed on the add button")
        performSegue(withIdentifier: S.boardDetail, sender: self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell") as! BoardTableViewCell
        
        let board = boards?[indexPath.row]
        
        cell.nameLabel.text = board?.name
        
        if board?.id == selectedBoard?.id {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did select row at index path \(indexPath)")
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == S.boardDetail {
            let navigationController = segue.destination as! UINavigationController
            let boardDetailViewController = navigationController.topViewController as! BoardDetailViewController
            
            // Duplicate project's statues
            let statuses = List<Status>()
            guard let projectStatuses = project?.statuses else { return }
            statuses.append(objectsIn: projectStatuses)
            
            boardDetailViewController.statuses = statuses //project?.statuses
        }
    }
}

extension BoardTableViewController {
    struct Segue {
        static let boardDetail = "BoardDetailViewControllerSegue"
    }
    typealias S = Segue
}
