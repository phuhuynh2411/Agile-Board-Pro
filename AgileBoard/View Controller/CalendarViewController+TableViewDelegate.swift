//
//  CalendarViewController+TableViewDelegate.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import SwipeCellKit

extension CalendarViewController: UITableViewDelegate, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let issue = issuesForSelectedDates?[indexPath.row] else { return }
        
        self.selectedIssue = issue
        performSegue(withIdentifier: editIssueSegue, sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard   orientation == .right else { return nil }
        
        let issue = issuesForSelectedDates?[indexPath.row]
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let alertController = UIAlertController(title:          "",
                                                    message:        "Are you sure you want to delete this issue permanently?",
                                                    preferredStyle: .actionSheet)
            
            let cancelAction    = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            let okAction        = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                do { try issue?.remove() }
                catch { print(error) }
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
}
