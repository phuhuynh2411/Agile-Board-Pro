//
//  DeleteZoneTableView+Datasource.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 3/3/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//
import UIKit

extension DeleteZoneTableView: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
    
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        }
    
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let item = coordinator.items.first else { return }
        guard let (issue, srcTableView, _ , srcIndexPath ) = item.dragItem.localObject
        as? (Issue, IssueTableView, UITableViewCell, IndexPath) else { return }
        
        do {
            try issue.remove()
        } catch { print(error) }
        
        srcTableView.deleteRows(at: [srcIndexPath], with: .automatic)
        srcTableView.fitVisibleCellHeight(minHeight: 40, animated: true, full: false)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidEnter session: UIDropSession) {
        self.backgroundView = self.imageForDeleteZone(isActive: true)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 10))
            self.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi + 10))
        }) { (complete) in
        }
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidExit session: UIDropSession) {
        self.backgroundView = self.imageForDeleteZone(isActive: false)
    }
}
