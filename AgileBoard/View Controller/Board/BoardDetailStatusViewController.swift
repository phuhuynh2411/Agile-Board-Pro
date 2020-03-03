//
//  BoardDetailStatusViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class BoardDetailStatusViewController: NSObject {
    
    var statuses: List<Status>?
    
    var project: Project?
    
    var collectionView: UICollectionView?

    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
    }
    
    // MARK: - IB Actions

}

// MARK: - UICollection View Datasource

extension BoardDetailStatusViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = statuses?.count ?? 0
        return count + 1 // add an extra cell, so we need to increase the count by 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell
        
        if indexPath.row == statuses?.count ?? 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastCell", for: indexPath)
        }else {
            let status = statuses?[indexPath.row]
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! BStatusCollectionViewCell
            itemCell.nameLabel.text = status?.name
            if let hexColor = status?.color?.hexColor {
                let uiColor = UIColor(hexString: hexColor)
                itemCell.backgroundColor = uiColor
                itemCell.nameLabel.textColor = UIColor().textColor(bgColor: uiColor)
            }
            itemCell.delegate = self
            cell = itemCell
        }
    
        // Make the cell round
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - View for collection header and footer
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var cellIdentifier = ""
        var viewType = ""
        var cell: UICollectionReusableView!
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            cellIdentifier = "HeaderCell"
            viewType = UICollectionView.elementKindSectionHeader
            
            cell = collectionView.dequeueReusableSupplementaryView(ofKind: viewType, withReuseIdentifier: cellIdentifier, for: indexPath)
            
            break
        default:
            fatalError("Undefine view")
        }
                
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        // Update the status count on the collection view's header.
        let headerView = view as! BStatusHeaderCell
        headerView.numberLabel.text = "\(statuses?.count ?? 0)"
        
    }
    
}

// MARK: - UICollection View Delegate

extension BoardDetailStatusViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItem(collectionView)
    }
    
    private func sizeForItem(_ collectionView: UICollectionView) ->CGSize {
        
        // Landscape mode
        var width = UIApplication.shared.statusBarOrientation.isLandscape ? collectionView.frame.width/2
            : collectionView.frame.width
        width -= 20

        let height:CGFloat = 44
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Tapped on the last cell
        // Add new status
        if indexPath.row == statuses?.count ?? 0 {
            let topViewController = UIApplication.getTopViewController()
            if let boardDetailViewController = topViewController as? BoardDetailViewController {
                boardDetailViewController.performSegue(withIdentifier: "AddStatusSegue", sender: self)
            }
        }
        
    }
}

// MARK: - UICollectionViewDragDelegate

extension BoardDetailStatusViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        // Do not allow user to drag the last cell.
        guard indexPath.row < statuses?.count ?? 0 else {return []}
        
        let status = statuses?[indexPath.row]
        dragItem.localObject = (status: status, collectionView: collectionView, indexPath: indexPath)
    
        return [dragItem]

    }
    
    
}

// MARK: - UICollectionViewDropDelegate

extension BoardDetailStatusViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let item = coordinator.items.first else { return }
        
        if let (column, srcCollectionView, srcIndexPath) = item.dragItem.localObject as? (Column, UICollectionView, IndexPath),
            let status = column.status {
            let lastIndexPath = IndexPath(row: statuses?.count ?? 0, section: 0)
            
            if let _ = statuses?.realm {
                statuses?.append(status, completion: nil)
            }else {
                statuses?.append(status)
            }
            collectionView.insertItems(at: [lastIndexPath])
            // Reload header
            collectionView.reloadHeader()
            
            // Remove column at source collection view
            // Remove the status at the source collection view
            if let datasource = srcCollectionView.dataSource as? BoardDetailColumnViewController,
                let srcColumns = datasource.columns {
                
                if let _ = srcColumns.realm {
                    srcColumns.remove(at: srcIndexPath.row, completion: nil)
                }else {
                    srcColumns.remove(at: srcIndexPath.row)
                }
                srcCollectionView.deleteItems(at: [srcIndexPath])
                srcCollectionView.reloadVisibleItems()
            }
            
        }
        
    }
    
}

// MARK: - SwipeCollectionViewCellDelegate

extension BoardDetailStatusViewController: SwipeCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        // Do not modify the last cell
        guard indexPath.row < statuses?.count ?? 0 else {return nil}
        
        var action: SwipeAction!
        
        if orientation == .right {
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                if let status = self.statuses?[indexPath.row] {
                    self.delete(status: status, at: indexPath)
                }
            }
            action = deleteAction
        }else{
            let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
                let topViewController = UIApplication.getTopViewController()
                if let boardDetailViewController = topViewController as? BoardDetailViewController {
                    boardDetailViewController.selectedStatus = self.statuses?[indexPath.row]
                    boardDetailViewController.performSegue(withIdentifier: "EditStatusSegue", sender: self)
                }
                action.fulfill(with: .reset)
            }
            
            action = editAction
        }

        return [action]
    }
    
    private func delete(status: Status, at indexPath: IndexPath) {
        if !isUsed(status: status){
            // Delete status in realm
            do { try status.remove()
            } catch { print(error) }
            // Also remove the status in the array
            statuses?.remove(at: indexPath.row)
            collectionView?.deleteItems(at: [indexPath])
        }else {
            let alertController = UIAlertController(title: "Warning", message: "You cannot delete the status because it is in use. Please change all related issues to another one and try again.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .default) { (action) in
    
            }
            alertController.addAction(cancelAction)
            let topViewController = UIApplication.getTopViewController()
            topViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // If the status is not in any issue, return true; otherwise, false
    func isUsed(status: Status)->Bool {
        return project!.issues.contains(where: { (issue) -> Bool in
            issue.status?.id == status.id
        })
    }
    
}
