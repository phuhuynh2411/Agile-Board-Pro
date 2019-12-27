//
//  BoardTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol BoardTableViewControllerDelegate {
    func didSelectBoard(board: Board)
}

class BoardTableViewController: UITableViewController {
    
    var boards: List<Board>?
    
    var selectedBoard: Board?
    
    var project: Project?
    
    var delegate: BoardTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove table view's extra seperators
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IB Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: S.addBoard, sender: self)
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
        if let board = boards?[indexPath.row] {
            delegate?.didSelectBoard(board: board)
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == S.addBoard {
            let navigationController = segue.destination as! UINavigationController
            let boardDetailViewController = navigationController.topViewController as! BoardDetailViewController
            
            // Duplicate project's statues
            let statuses = List<Status>()
            guard let projectStatuses = project?.statuses else { return }
            statuses.append(objectsIn: projectStatuses)
            
            boardDetailViewController.statuses = statuses //project?.statuses
            boardDetailViewController.project = project
            let columns = List<Column>()
            boardDetailViewController.columns = columns
            boardDetailViewController.delegate = self
        }
    }
}

extension BoardTableViewController {
    struct Segue {
        static let addBoard = "AddBoardSegue"
    }
    typealias S = Segue
}

// MARK: - BoardDetailViewControllerDelegate

extension BoardTableViewController: BoardDetailViewControllerDelegate {
    
    func didAddBoard(board: Board) {
        if let project = project {
            ProjectController.shared.add(board: board, to: project)
            tableView.reloadData()
        }
    }
    
    func didModifyBoard(board: Board) {
        
    }
}
