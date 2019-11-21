//
//  RowTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var issueCollectionView: UICollectionView!
    @IBOutlet weak var assigneeCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var issueList: NSMutableArray?
    
    var columnIndexPath: IndexPath?
    
    // a initial frame of Issue Collection View
    var initialFrame: CGRect?
    
    var issueTableView: IssueTableView?
    
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
    
    // MARK: - Drag and Drop Zone
    
//    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
//
//        print("Long press recognized")
//
//        let longpress = gestureRecognizer as! UILongPressGestureRecognizer
//        let state = longpress.state
//        let locationInView = longpress.location(in: self.tableView)
//        let indexPath = self.tableView.indexPathForRow(at: locationInView)
//
//        switch state {
//        case .began:
//            if indexPath != nil {
//                Path.initialIndexPath = indexPath
//                let cell = self.tableView.cellForRow(at: indexPath!) as! IssueTableViewCell
//                My.cellSnapShot = snapshopOfCell(inputView: cell)
//                var center = cell.center
//                My.cellSnapShot?.center = center
//                My.cellSnapShot?.alpha = 0.0
//                self.tableView.addSubview(My.cellSnapShot!)
//
//                UIView.animate(withDuration: 0.25, animations: {
//                    center.y = locationInView.y
//                    My.cellSnapShot?.center = center
//                    My.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//                    My.cellSnapShot?.alpha = 0.98
//                    cell.alpha = 0.0
//                }, completion: { (finished) -> Void in
//                    if finished {
//                        cell.isHidden = true
//                    }
//                })
//            }
//
//        case .changed:
//            var center = My.cellSnapShot?.center
//            center?.y = locationInView.y
//            My.cellSnapShot?.center = center!
//            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
//
//                self.issueList?.swapAt((indexPath?.row)!, (Path.initialIndexPath?.row)!)
//                //swap(&self.wayPoints[(indexPath?.row)!], &self.wayPoints[(Path.initialIndexPath?.row)!])
//                self.tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
//                Path.initialIndexPath = indexPath
//            }
//
//        default:
//            let cell = self.tableView.cellForRow(at: Path.initialIndexPath!) as! IssueTableViewCell
//            cell.isHidden = false
//            cell.alpha = 0.0
//            UIView.animate(withDuration: 0.25, animations: {
//                My.cellSnapShot?.center = cell.center
//                My.cellSnapShot?.transform = .identity
//                My.cellSnapShot?.alpha = 0.0
//                cell.alpha = 1.0
//            }, completion: { (finished) -> Void in
//                if finished {
//                    Path.initialIndexPath = nil
//                    My.cellSnapShot?.removeFromSuperview()
//                    My.cellSnapShot = nil
//                }
//            })
//        }
//    }
//
//    func snapshopOfCell(inputView: UIView) -> UIView {
//
//        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
//        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        let cellSnapshot : UIView = UIImageView(image: image)
//        cellSnapshot.layer.masksToBounds = false
//        cellSnapshot.layer.cornerRadius = 0.0
//        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
//        cellSnapshot.layer.shadowRadius = 5.0
//        cellSnapshot.layer.shadowOpacity = 0.4
//        return cellSnapshot
//    }
//
//    struct My {
//        static var cellSnapShot: UIView? = nil
//    }
//
//    struct Path {
//        static var initialIndexPath: IndexPath? = nil
//    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.IssueTableViewCell, for: indexPath) as! IssueTableViewCell
        
        let issue = issueList?[indexPath.row] as! Issue
        cell.summaryLabel.text = issue.summary
        
        //print(Unmanaged.passUnretained(issueList[0]!).toOpaque())
                
        print("Table view cell is loading")
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
        print("Move row at \(sourceIndexPath) to \(destinationIndexPath)")
    }
    
}

// MARK: - UITableViewDragDelegate

extension IssueTableViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        //let issue = issueList?[indexPath.row]
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let dragIssue = DragIssueItem(issueList: issueList, indexPath: indexPath, tableView: tableView)
        dragItem.localObject = dragIssue
        
        return [dragItem]
        
    }
    
}

// MARK: - UITableViewDropDelegate

extension IssueTableViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        for item in coordinator.items {
            
            guard let dragIssueItem = item.dragItem.localObject as? DragIssueItem else { return }
            
            let sourceIssueList = dragIssueItem.issueList
            let sourceIndexPath = dragIssueItem.indexPath
            let sourceTableView = dragIssueItem.tableView
            
            // Add drag item to the destination
            let issue = sourceIssueList![sourceIndexPath.row]
            issueList?.insert(issue, at: destinationIndexPath.row)

            // Remove the drag item from the source
        
            
            sourceIssueList?.remove(issue)
            sourceTableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            //sourceTableView.reloadData()

            tableView.reloadData()
        }
        
    }
    
}
