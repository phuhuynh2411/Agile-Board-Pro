//
//  BoardTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

protocol BoardTableViewControllerDelegate {
    func didSelectBoard(board: Board)
}

class BoardTableViewController: UITableViewController {
    
    private var boards: List<Board>?
    
    private var selectedBoard: Board?
    
    private var editedBoard: Board?
    
    var project: Project?
    
    var delegate: BoardTableViewControllerDelegate?
    
    private var notificationToken: NotificationToken?

    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initilize the boards
        boards = project?.boards
        selectedBoard = project?.selectedBoard
        
        // Remove table view's extra seperators
        tableView.tableFooterView = UIView()
        
        // Add fine-grained notification block
        notificationToken = boards?.observe { [weak self] (changes) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_ , let deletions, let insertions, let modifications):
                print("Table view has been updated.")
                
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                 //Always apply updates in the following order: deletions, insertions, then modifications.
                 //Handling insertions before deletions may result in unexpected behavior.
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // handle error
                print(error)
            }
        }

    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationToken?.invalidate()
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
        cell.delegate = self
        
        let board = boards?[indexPath.row]
        
        cell.nameLabel.text = board?.name
        
        if board?.id == selectedBoard?.id {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
            // Do nothing if there are no statuses in the project
            guard let projectStatuses = project?.statuses else { return }

            let navigationController = segue.destination as! UINavigationController
            let boardDetailViewController = navigationController.topViewController as! BoardDetailViewController
            
            // Duplicate project's statues
            let availableStatuses = List<Status>()
            availableStatuses.append(objectsIn: projectStatuses)
            
            boardDetailViewController.availableStatuses = availableStatuses //project?.statuses
            boardDetailViewController.project = project
            boardDetailViewController.delegate = self
        }
        else if segue.identifier == S.editBoard {
            // Do nothing if there are no statuses in the project
            guard let projectStatuses = project?.statuses, let board = editedBoard else { return }

            let navigationController = segue.destination as! UINavigationController
            let boardDetailViewController = navigationController.topViewController as! BoardDetailViewController
                        
            // Gets a list of status that have been added to the columns.
            let columnStatuses: [Status] = board.columns.compactMap { (column) -> Status in
                column.status!
            }
            
            // Return a list of statuses that are not in the columns
            let notInColumnStatuses = projectStatuses.filter { (status) -> Bool in
                !columnStatuses.contains(status)
            }
            let availableStatuses = List<Status>()
            availableStatuses.append(objectsIn: notInColumnStatuses)
            
            boardDetailViewController.availableStatuses = availableStatuses
            boardDetailViewController.project = project
            
            boardDetailViewController.board = board
            boardDetailViewController.delegate = self
        }
    }
}

extension BoardTableViewController {
    struct Segue {
        static let addBoard = "AddBoardSegue"
        static let editBoard = "EditBoardSegue"
    }
    typealias S = Segue
}

// MARK: - BoardDetailViewControllerDelegate

extension BoardTableViewController: BoardDetailViewControllerDelegate {
    
    func didAddBoard(board: Board) {
        boards?.append(board, completion: nil)
    }
}

// MARK: - SwipeCellDelegate

extension BoardTableViewController: SwipeTableViewCellDelegate {
   
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var action: SwipeAction!
        
        if orientation == .right {
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                self.deleteBoard(at: indexPath)
            }
            action = deleteAction
        }else{
            let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
                self.editedBoard = self.boards?[indexPath.row]
                self.performSegue(withIdentifier: S.editBoard, sender: self)
            }
            
            action = editAction
        }
        
        return [action]
    }
    
    private func deleteBoard(at indexPath: IndexPath) {
        if let board = boards?[indexPath.row], let selectedBoard = selectedBoard {
            // Could not delete the board because it is used as the main board.
            if selectedBoard.isEqual(board) {
                let alertController = UIAlertController(title: "Delete board", message: "Could not delete this board because you are using it as the main board.", preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
            // Delete the board
            else {
                boards?.remove(at: indexPath.row, completion: nil)
            }
        }
    }
    
}
