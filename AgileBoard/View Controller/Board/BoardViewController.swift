//
//  ViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class BoardViewController: UIViewController {
        
    // MARK: - Outlets
    
    @IBOutlet weak var pageControl: IssuePageControlView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionController: IssueCollectionController?
    
    // Project
    var project: Project?
    
    var boardTransitioningDelegate: BoardTransitioningDelegate?
    
    var customView: BoardTitleView = .fromNib()
    
    var notificationToken: NotificationToken?
            
    override func viewDidLoad() {
        
        // Set the number of pages for the page control
        let columns = project?.boards.first?.columns
        self.pageControl.numberOfPages = columns?.count ?? 0
        
        // Custom navigation title view
        navigationItem.titleView = customView
        
        // Init the selected board
        if project?.selectedBoard == nil {
            project?.write(code: {
                project?.selectedBoard = project?.boards.first
            }, completion: nil)
        }
        
        // Update board name
        customView.titleButton.setTitle(project?.selectedBoard?.name, for: .normal)
        
        // Add action for the title view
        customView.titleButton.addTarget(self, action: #selector(titleViewPressed(_sender:)), for: .touchUpInside)
        
        // Customize left bar button
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_left_arrow"), style: .plain, target: self, action: #selector(leftButtonPress(_:)))
        navigationItem.leftBarButtonItem = leftBarButton
        
        // Set up collection view
        collectionController = IssueCollectionController(collectionView: collectionView)
        collectionController?.project = project
        //collectionController?.selectedBoard = project?.selectedBoard
        
        notificationToken = project?.selectedBoard?.observe({ (change) in
            switch change {
            case .change(_):
                print("The selected board has been changed.")
                self.selectedBoardDidChange()
                break
            case .deleted:
                print("The selected board has been deleted.")
                break
            case .error(let error):
                print("An error occured \(error)")
                break
            }
        })
        
        // Pass the page control through the collection view
        collectionController?.pageControl = pageControl
        
        // Show or hide page controll
        showHidePageControl()
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        notificationToken?.invalidate()
    }
    
    func showHidePageControl() {
        
        if UIDevice.current.orientation.isLandscape {
            pageControl.setVisible(state: false, with: 10)
        }
        else {
            pageControl.setVisible(state: true, with: 37)
        }
    }
    
    // MARK: - Helper Methods
    
    private func selectedBoardDidChange() {
        // Re-update the total page number
        pageControl.numberOfPages = project?.selectedBoard?.columns.count ?? 0
        
        // Update board name and reload the collection view
        customView.titleButton.setTitle(project?.selectedBoard?.name, for: .normal)
        collectionView.reloadData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Identifier.AddIssueTableViewControllerSegue, sender: self)
    }
    
    @IBAction func titleViewPressed(_sender: UIButton) {
        performSegue(withIdentifier: S.boardTableView, sender: self)
    }
    
    @IBAction func leftButtonPress(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the current project to the Add Issue View Controller
        if segue.identifier == Identifier.AddIssueTableViewControllerSegue {
            
            let navigationController = segue.destination as! UINavigationController
            let addIssueTableViewController =  navigationController.topViewController as! IssueDetailTableViewController
            let selectedBoard = project?.selectedBoard
            
            addIssueTableViewController.initView(with: project, issueType: IssueTypeController.shared.default(), priority: PriorityController.shared.default(),startDate: Date(), status: selectedBoard?.columns.first?.status, delegate: self)
            
        }
        if segue.identifier == S.boardTableView {
            let navigationController = segue.destination as! UINavigationController
            let boardTableViewController =  navigationController.topViewController as! BoardTableViewController

            boardTableViewController.project = project
            boardTableViewController.delegate = self
            
            boardTransitioningDelegate = BoardTransitioningDelegate()
            segue.destination.transitioningDelegate = boardTransitioningDelegate
            segue.destination.modalPresentationStyle = .custom
        }
    }
    
    
}

// MARK: - Orientation Changes

extension BoardViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Show or hide the page control
        showHidePageControl()

        // Reload the collection data when users change the orientation
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        
    }
    
}

// MARK: - Add Issue Delegate

extension BoardViewController: IssueDetailDelegate {
    func didModidyIssue(issue: Issue) {
        // Do something here
    }
    
    
    func didAddIssue(with issue: Issue, project: Project?) {
        if let project = project {
            ProjectController.shared.add(issue: issue, to: project)
            // Reload the collection view
            collectionView.reloadData()
        }
    }
}

extension BoardViewController {
    private struct SegueIdentifier {
        static let searchProject = "SearchProjectSegue"
        static let issueType = "SelectIssueTypeSegue"
        static let priority = "SelectPrioritySegue"
        static let dueDate = "DueDateSegue"
        static let startDate = "StartDateSegue"
        static let endDate = "EndDateSegue"
        static let boardTableView = "BoardTableViewControllerSegue"
    }
    private typealias S = SegueIdentifier
}


// MARK: - UIViewControllerTransitioningDelegate

extension BoardViewController {
    
    class BoardTransitioningDelegate: UIViewController, UIViewControllerTransitioningDelegate {
        
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            
            let halfScreenPresentationController = HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
            
            halfScreenPresentationController.presentedViewHeight = view.frame.height/2
            halfScreenPresentationController.presentedCornerRadius = 10.0
            
            return halfScreenPresentationController
        }
    }
    
}

// MARK: - BoardTableViewControllerDelegate

extension BoardViewController: BoardTableViewControllerDelegate {
    
    func didSelectBoard(board: Board) {
        project?.write(code: {
            project?.selectedBoard = board
        }, completion: nil)
        
        // Refresh the selected board
        selectedBoardDidChange()
    }
    
}
