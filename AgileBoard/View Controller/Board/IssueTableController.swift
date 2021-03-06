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
    
    var displayedIssues: Results<Issue>?
    var selectedIssue: Issue?
    var issues: List<Issue>?
    
    var column: Column?
    var tableView: UITableView?
    
    var copyOfSelectedIssue: Issue?
    
    let realm = AppDataController.shared.realm
    
    var deleteZoneTableView: DeleteZoneTableView?
    
    private var isStartDragging = false
                
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.estimatedRowHeight = 44
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        // Register custome cell
        let nibName = UINib(nibName: I.issueTVC, bundle: .main)
        tableView.register(nibName, forCellReuseIdentifier: I.issueTVC)
    }

    // MARK: - Help Methods
    
    func viewDetail(issue: Issue) {
        
        guard let project = issue.projectOwners.first else {
            fatalError("The project should not be nil at this point.")
        }
        
        let vc = UIStoryboard(name: I.storyBoard, bundle: .main).instantiateViewController(withIdentifier: I.issueDetailVC) as! IssueDetailTableViewController
        
        vc.issue    = issue
        vc.project  = project
        vc.delegate = self
        
        let topViewController = UIApplication.getTopViewController()
        let nav = UIStoryboard(name: I.storyBoard, bundle: .main).instantiateViewController(withIdentifier: I.issueDetailNC) as! UINavigationController
        nav.viewControllers = [vc]
        
        topViewController?.present(nav, animated: true, completion: nil)
        
    }

}

// MARK: - UITableView Datasource

extension IssueTableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfRow = displayedIssues?.count ?? 0
        
        // Update the number of issues
        let issueTableView = tableView as! IssueTableView
        issueTableView.issueCountLabel?.text = "\(numberOfRow)"
        
        return numberOfRow
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: I.issueTVC, for: indexPath) as! IssueTableViewCell
        cell.translatesAutoresizingMaskIntoConstraints = false
        
        let issue = displayedIssues?[indexPath.row]
        if let imageName = issue?.type?.imageName {
            cell.issueTypeImageView.image = UIImage(named: imageName)
        }
        
        cell.summaryLabel.text = issue?.summary
        cell.issueIDLabel.text = issue?.issueID
        if let priorityImageName = issue?.priority?.imageName {
            cell.priorityImageView.image = UIImage(named: priorityImageName)
        }
        // Show number of the attachments
        let attachmentCount = issue?.attachments.count ?? 0
        cell.numberOfAttachmentsLabel.text = "\(attachmentCount > 0 ? "\(attachmentCount)" : "")"
        cell.attachmentImageView.image = attachmentCount > 0 ? UIImage(named: "Attachment") : .none
                    
        return cell
    }
    
    func dataForTableView(with issues: List<Issue>,and column: Column) {
        self.issues = issues ; self.column = column
        guard let status = column.status else { return }
        displayedIssues = issues.filter("status = %@", status)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - UITableView Delegate

extension IssueTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if let srcIssue = displayedIssues?[sourceIndexPath.row], let sourceIndex = issues?.index(of: srcIssue) {
            do {
                try realm?.write{
                    issues?.move(from: sourceIndex, to: destinationIndexPath.row)
                }
            } catch { print(error) }
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIssue = displayedIssues?[indexPath.row]
        
        if let issue = selectedIssue {
            copyOfSelectedIssue = Issue(value: issue)
            viewDetail(issue: issue)
        }
    }
    
}

// MARK: - UITableViewDragDelegate

extension IssueTableController: UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        
        //let dragIssue = DragIssueItem(issueList: displayedIssues!, indexPath: indexPath, tableView: tableView, cell: cell!)
        if let issue = displayedIssues?[indexPath.row], let cell = tableView.cellForRow(at: indexPath){
            let dragIssue = (issue: issue, tableView: tableView, cell: cell, indexPath: indexPath)
            dragItem.localObject = dragIssue
            session.localContext = dragIssue
        }
        
        // Add delete zone
        if deleteZoneTableView == nil {
            deleteZoneTableView = DeleteZoneTableView(frame: .zero, style: .plain)
            // If user is not dragging the item after 4 second. Auto removes the delete zone.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if !self.isStartDragging { self.removeDeleteZone() }
            }
        }
        
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
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        // User starts dragging the item
        self.isStartDragging = true
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        self.removeDeleteZone()
        self.isStartDragging = false
    }

}

// MARK: - UITableViewDropDelegate

extension IssueTableController: UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        guard
            let item = coordinator.items.first,
            let (issue, srcTableView, cell, srcIndexPath ) = item.dragItem.localObject
            as? (Issue, IssueTableView, UITableViewCell, IndexPath) else { return }

        let desIndexPath: IndexPath
        
        if let destinationIndexPath = coordinator.destinationIndexPath{
            desIndexPath = destinationIndexPath
        }
        // Draging an issue into an empty table view
        else {
            desIndexPath = IndexPath(row: 0, section: 0)
        }
        if let moveToIndex = issues?.index(of: issue) {
            do{
                try issue.write { issue.status = column?.status }
                try realm?.write { issues?.move(from: moveToIndex, to: desIndexPath.row) }
            } catch { print(error) }
        }
        
        // Reload the destination table view
        let destinationTableView = tableView as! IssueTableView
        // Only increase the cell height if the number of rows is greater than one
        if destinationTableView.numberOfRows(inSection: 0) == 0 {
            destinationTableView.setHeight(height: cell.frame.height, animated: true)
        }else {
            destinationTableView.increaseHeight(with: cell.frame.height)
        }
        
        //tableView.insertRows(at: [desIndexPath], with: .automatic)
        // Animates the item to the specificed index path in the table view
        //coordinator.drop(item.dragItem, toRowAt: desIndexPath)
        tableView.reloadData()

        srcTableView.deleteRows(at: [srcIndexPath], with: .automatic)
        srcTableView.fitVisibleCellHeight(minHeight: 40, animated: true, full: false)

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
    
    private func removeDeleteZone() {
        guard deleteZoneTableView != nil else { return }
        self.deleteZoneTableView?.delete()
        self.deleteZoneTableView = nil
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


// MARK: - Issue Detail Delegate

extension IssueTableController: IssueDetailDelegate {
    
    func didModify(_ issue: Issue) {
        tableView?.reloadData()
        // reload the collection view if issue's status has been changed.
        if copyOfSelectedIssue?.status != issue.status ||
            copyOfSelectedIssue?.projectOwners.first != issue.projectOwners.first {
            
            let boardViewController = UIApplication.getTopViewController() as? BoardViewController
            boardViewController?.collectionView.reloadData()
        }
    }
}
