//
//  RowTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class IssueTableController: NSObject {
    
    // MARK: - Properties
    
    var issueList: List<Issue>?
    var selectedIssue: Issue?
    
    var column: Column?
    var tableView: UITableView?
    
    var realm = try! Realm()
    
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
        // Register custome cell
        let nibName = UINib(nibName: I.issueTVC, bundle: .main)
        tableView.register(nibName, forCellReuseIdentifier: I.issueTVC)
    }
    
    // MARK: - Help Methods
    
    func viewDetail(issue: Issue) {
        
        guard let project = issue.projectOwners.first else {
            fatalError("The project should not be nil at this point.")
        }
        
        let issueDetailTableViewController = UIStoryboard(name: I.storyBoard, bundle: .main).instantiateViewController(withIdentifier: I.issueDetailVC) as! IssueDetailTableViewController
        
        issueDetailTableViewController.initView(with: issue, project: project)
        //issueDetailTableViewController.modalPresentationStyle = .fullScreen
        
        let topViewController = UIApplication.getTopViewController()
        let nav = UIStoryboard(name: I.storyBoard, bundle: .main).instantiateViewController(withIdentifier: I.issueDetailNC) as! UINavigationController
        nav.viewControllers = [issueDetailTableViewController]
        
        topViewController?.present(nav, animated: true, completion: nil)
        
    }
    
    
    
}

// MARK: - UITableView Datasource

extension IssueTableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRow = issueList?.count ?? 0
        
        // Update the number of issues
        let issueTableView = tableView as! IssueTableView
        issueTableView.issueCountLabel?.text = "\(numberOfRow)"
        
        return numberOfRow
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: I.issueTVC, for: indexPath) as! IssueTableViewCell
        
        let issue = issueList?[indexPath.row]
        if let imageName = issue?.type?.imageName {
            cell.issueTypeImageView.image = UIImage(named: imageName)
        }
        
        cell.summaryLabel.text = issue?.summary
        cell.issueIDLabel.text = issue?.issueID
                    
        return cell
    }
    
    func dataForTableView(with issueList: Results<Issue>?,and column: Column) {
        
        guard let issues = issueList else { return }
        
        self.issueList = List<Issue>()
        self.issueList?.append(objectsIn: issues)
        self.column = column
        
    }
}

// MARK: - UITableView Delegate

extension IssueTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // Remove the dashed rectangle if any
        let issueTableView = tableView as! IssueTableView
        issueTableView.removeDashedBorder()
        
        print("Move row at \(sourceIndexPath) to \(destinationIndexPath)")
        let sourceIssue = issueList?[sourceIndexPath.row]
        do{
            try realm.write {
                 //issueList?.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
                issueList?.swapAt(sourceIndexPath.row, destinationIndexPath.row)
            }
        }catch let error as NSError {
            print(error.description)
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIssue = issueList?[indexPath.row]
        if let issue = selectedIssue {
            viewDetail(issue: issue)
        }
        
    }
    
}

// MARK: - UITableViewDragDelegate

extension IssueTableController: UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let cell = tableView.cellForRow(at: indexPath)
        let dragIssue = DragIssueItem(issueList: issueList!, indexPath: indexPath, tableView: tableView, cell: cell!)
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

extension IssueTableController: UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        let dragIssueItem = session.localDragSession?.localContext as! DragIssueItem
        let sourceTableView = dragIssueItem.tableView
        let cell = dragIssueItem.cell
        let issueTableView = tableView as! IssueTableView
        let sourceInDexPath = dragIssueItem.indexPath
        
        // Remove dashed border
        issueTableView.removeDashedBorder()
        
        // Add an animation when dragging through an empty table view
        if  tableView.numberOfRows(inSection: 0) == 0{
            issueTableView.setHeight(height: cell.frame.height, animated: true)
            issueTableView.addDashedBorder(at: cell.frame)

        }
        // Add a dashed rectangle at the drop position
        else {
            if let desIndexPath = destinationIndexPath, let desCell = tableView.cellForRow(at: desIndexPath) {
                
                // MOVE AN ITEM INSIDE THE TABLE VIEW
                // Change the frame's height based on the drop possition
                var minY = desIndexPath < sourceInDexPath ? desCell.frame.minY - cell.frame.height : desCell.frame.maxY
                // If dragging and dropping at the same index path
                // The minY should be equal to the source cell's min Y
                minY = desIndexPath == sourceInDexPath ? cell.frame.minY : minY
                
                var height = cell.frame.height
                
                // MOVE AN ITEM FROM A TABLE VIEW TO ANOTHER ONE
                if sourceTableView != tableView {
                    // Recalculate the Y position
                    minY = desCell.frame.minY - desCell.frame.height
                    height = desCell.frame.height
                }
                
                let frame = CGRect(x: desCell.frame.minX, y: minY, width: cell.frame.width, height: height)
                issueTableView.addDashedBorder(at: frame)
                
            }
            // MOVE AN ITEM TO ANOTHER TABLE VIEW
            // When users drag the item after the last item
            else if let desIndexPath = destinationIndexPath{
                
                let lastIndexPath = IndexPath(item: desIndexPath.row - 1, section: desIndexPath.section)
                
                if let lastCell = tableView.cellForRow(at: lastIndexPath) {
                    let height = lastCell.frame.height
                    let newY = lastCell.frame.maxY
                    let frame = CGRect(x: cell.frame.minX, y: newY, width: cell.frame.width, height: height)
                    issueTableView.addDashedBorder(at: frame)
                }
                
            }
            else {
                print("New case which has not been handel by code yet!!!")
            }
            
        }

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
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
                    issue.status = column?.status
                    issueList?.insert(issue, at: destinationIndexPath.row)

                }
                tableView.insertRows(at: [destinationIndexPath], with: .automatic)

            }
            // Draging an issue into an empty table view
            else {
                try! realm.write {
                    issue.status = column?.status
                    issueList?.append(issue)

                }
                tableView.reloadData()
            }

            // Remove the drag item from the source
            // sourceIssueList?.remove(issue)
            try! realm.write {
                sourceIssueList.remove(at: sourceIndexPath.row)
            }
            sourceTableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            sourceTableView.fitVisibleCellHeight(minHeight: 40, animated: true, full: false)
            sourceTableView.reloadData()

            // Reload the destination table view
            let destinationTableView = tableView as! IssueTableView
            
            // Only increase the cell height if the number of rows is greater than one
            if destinationTableView.numberOfRows(inSection: 0) > 1 {
                destinationTableView.increaseHeight(with: cell!.frame.height)
            }
            destinationTableView.reloadData()

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

// MARK: - Identifier

extension IssueTableController {
    private struct VCIdentifier {
        static let issueDetailVC = "AddIssueTableViewController"
        static let issueTVC = "IssueTableViewCell"
        static let storyBoard = "Main"
        static let issueDetailNC = "IssueDetailNavigationController"
    }
    private typealias I = VCIdentifier
}
