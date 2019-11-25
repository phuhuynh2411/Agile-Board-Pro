//
//  RowTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class IssueTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var issueCollectionView: UICollectionView!
    @IBOutlet weak var assigneeCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var issueList: List<Issue>?
    var collumn: Column?
    
    var columnIndexPath: IndexPath?
    
    // a initial frame of Issue Collection View
    var initialFrame: CGRect?
    
    var issueTableView: IssueTableView?
    
    lazy var realm = try! Realm()
    
    // MARK: - Init Methods
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        
        // Register custome cell
        let nibName = UINib(nibName: Identifier.IssueTableViewCell, bundle: .main)
        tableView.register(nibName, forCellReuseIdentifier: Identifier.IssueTableViewCell)
        
     
    }
    
    override func viewDidLayoutSubviews() {
        
        // Because creating the UITableViewController programaticaly,
        // the tableView properity is nil by default
        // Need to assign this property to IssueTableView
        if let tbView = issueTableView {
            tableView = tbView
        }
        
        // Add long gesture to the tableview in order to perfrom drag and drop operation
        // let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        // self.tableView.addGestureRecognizer(longpress)
        
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRow = issueList?.count ?? 0
        issueTableView?.countLabel?.text = "\(numberOfRow)"
        return numberOfRow
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.IssueTableViewCell, for: indexPath) as! IssueTableViewCell
        
        let issue = issueList?[indexPath.row]
        
        cell.summaryLabel.text = issue?.summary
                    
        return cell
    }
    
    // MARK: - Pan Gesture
    
    @objc func panAction(gestureRecognizer: UIPanGestureRecognizer) {
        
        guard gestureRecognizer.view != nil else {return}
        //let view = gestureRecognizer.view!
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            
            // Move the issue collection view up or down
            let center = issueCollectionView.center
            issueCollectionView.center = CGPoint(x: center.x, y: center.y + translation.y)
            
            // Issue Collection Frame
            let minY = issueCollectionView.frame.minY
            let minX = issueCollectionView.frame.minX
            let with = issueCollectionView.frame.width
            let height = issueCollectionView.frame.height
            
            // If issue collection's frame y is less than or equal to assign collection's frame y
            // Set issue collection y to assignee collection y
            if minY <= assigneeCollectionView.frame.minY {
                issueCollectionView.frame = CGRect(x: minX, y: assigneeCollectionView.frame.minY, width: with, height: height)
            }
            
            // If issue collection's frame y is greater than or equal to the its initial frame
            // Set its current y to its initial y
            if minY >= initialFrame!.minY {
                issueCollectionView.frame = initialFrame!
            }
                        
            gestureRecognizer.setTranslation(CGPoint.zero, in: issueCollectionView)
        }
    }
}

// MARK: - UITableView Delegate

extension IssueTableViewController {
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // Remove the dashed rectangle if any
        let issueTableView = tableView as! IssueTableView
        issueTableView.removeDashedBorder()
        
        print("Move row at \(sourceIndexPath) to \(destinationIndexPath)")
       // let sourceIssue = issueList[sourceIndexPath.row]
        do{
            try realm.write {
                 //issueList?.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
                issueList?.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            }
        }catch let error as NSError {
            print(error.description)
        }
    }
    
}

// MARK: - UITableViewDragDelegate

extension IssueTableViewController: UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let dragIssue = DragIssueItem(issueList: issueList!, indexPath: indexPath, tableView: tableView)
        dragItem.localObject = dragIssue
        session.localContext = dragIssue

        return [dragItem]

    }

    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {

        // Get cell at index path
        let cell = tableView.cellForRow(at: indexPath)

        let previewParameter = UIDragPreviewParameters()

        // Change the background color
        previewParameter.backgroundColor = .none

        // make the cell round when draging
        let padding: CGFloat = 8.0
        let bounds = cell!.bounds
        let rect = CGRect(x: padding, y: padding/2, width: bounds.width - padding * 2, height: bounds.height - padding)

        previewParameter.visiblePath = UIBezierPath(roundedRect: rect, cornerRadius: 7.0)

        return previewParameter
    }

}

// MARK: - UITableViewDropDelegate

extension IssueTableViewController: UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        let dragIssueItem = session.localDragSession?.localContext as! DragIssueItem
        let sourceTableView = dragIssueItem.tableView
        let cell = sourceTableView.cellForRow(at: dragIssueItem.indexPath)
        let issueTableView = tableView as! IssueTableView
        let sourceInDexPath = dragIssueItem.indexPath
        
        // Add an animation when dragging through an empty table view
        if  tableView.numberOfRows(inSection: 0) == 0 {
            issueTableView.setTableViewHeight(height: cell!.frame.height, animated: true)
            issueTableView.addDashedBorder()

        }
        // Add a dashed rectangle at the drop position
        else {
            if let desIndexPath = destinationIndexPath, let desCell = tableView.cellForRow(at: desIndexPath) {
                
                // MOVE AN ITEM INSIDE THE TABLE VIEW
                // Change the frame's height based on the drop possition
                var newY = desIndexPath < sourceInDexPath ? desCell.frame.minY - cell!.frame.height : desCell.frame.maxY
                var height = cell!.frame.height
                // Revert the frame's height if draging and dropping at the same position
                if sourceInDexPath == desIndexPath {
                    newY = desCell.frame.minY
                }
                
                // MOVE AN ITEM FROM A TABLE VIEW TO ANOTHER ONE
                if sourceTableView != tableView {
                    // Recalculate the Y position
                    newY = desCell.frame.minY - desCell.frame.height
                    height = desCell.frame.height
                }
                
                let frame = CGRect(x: desCell.frame.minX, y: newY, width: cell!.frame.width, height: height)
                issueTableView.addDashedBorder(at: frame)
                

            }
            // MOVE AN ITEM TO ANOTHER TABLE VIEW
            // When users drag the item after the last item
            else if let desIndexPath = destinationIndexPath {
                
                let lastIndexPath = IndexPath(item: desIndexPath.row - 1, section: desIndexPath.section)
                
                if let lastCell = tableView.cellForRow(at: lastIndexPath) {
                    let height = lastCell.frame.height
                    let newY = lastCell.frame.maxY
                    let frame = CGRect(x: cell!.frame.minX, y: newY, width: cell!.frame.width, height: height)
                    issueTableView.addDashedBorder(at: frame)
                }
                
            }
            
        }

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, dropSessionDidEnd session: UIDropSession) {

        let issueTableView = tableView as! IssueTableView
        // issueTableView.removeDashedBorder()
        issueTableView.makeCellFitTableHeight(animated: true)

    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        // Remove the dashed rectangle if any
        let issueTableView = tableView as! IssueTableView
        issueTableView.removeDashedBorder()

        for item in coordinator.items {

            guard let dragIssueItem = item.dragItem.localObject as? DragIssueItem else { return }

            let sourceIssueList = dragIssueItem.issueList
            let sourceIndexPath = dragIssueItem.indexPath
            let sourceTableView = dragIssueItem.tableView as! IssueTableView
            // Get source table view's cell
            let cell = sourceTableView.cellForRow(at: sourceIndexPath)
            let issue = sourceIssueList[sourceIndexPath.row]


            if let destinationIndexPath = coordinator.destinationIndexPath{
                // Add drag item to the destination
                try! realm.write {
                    issue.status = collumn?.status
                    issueList?.insert(issue, at: destinationIndexPath.row)

                }
                // issueList?.insert(issue, at: destinationIndexPath.row)
                tableView.insertRows(at: [destinationIndexPath], with: .automatic)

            }
            // Draging an issue into an empty table view
            else {
                try! realm.write {
                    issue.status = collumn?.status
                    issueList?.append(issue)

                }
                // issueList?.add(issue)
                tableView.reloadData()
            }

            // Remove the drag item from the source
            // sourceIssueList?.remove(issue)
            try! realm.write {
                sourceIssueList.remove(at: sourceIndexPath.row)
            }
            sourceTableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            sourceTableView.makeCellFitTableHeight(animated: true)

            // Reload the destination table view
            let destinationTableView = tableView as! IssueTableView
            destinationTableView.reloadData()
            // Only increase the cell height if the number of rows is greater than one
            if destinationTableView.numberOfRows(inSection: 0) > 1 {
                destinationTableView.increaseTableHeight(with: cell!.frame.height)
            }

        }

    }

    func tableView(_ tableView: UITableView, dropPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {

        // Get cell at index path
        let cell = tableView.cellForRow(at: indexPath)

        let previewParameter = UIDragPreviewParameters()

        // Change the background color
        previewParameter.backgroundColor = .none

        // make the cell round when draging
        let padding: CGFloat = 7.0
        let bounds = cell!.bounds
        let rect = CGRect(x: padding, y: padding, width: bounds.width - padding * 2, height: bounds.height - padding * 2)

        previewParameter.visiblePath = UIBezierPath(roundedRect: rect, cornerRadius: 7.0)

        return previewParameter
        
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidExit session: UIDropSession) {
        
        // Remove the dashed rectangle if users drag the item
        // outside of the table view
        let issueTableView = tableView as! IssueTableView
        issueTableView.removeDashedBorder()
        
    }

    
}
