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
    
    @IBOutlet weak var collectionView: IssueCollectionView!
    
    // Project
    var project: Project?
    
    var board: Board?
        
    override func viewDidLoad() {
        
        // Set the number of pages for the page control
        let columns = project?.boards.first?.columns
        self.pageControl.numberOfPages = columns?.count ?? 0
        
        // Set the navigation item title to the project name
        navigationItem.title = project?.name
        
        //self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        // Select first board as default
        board = project?.boards.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.controller?.project = project
    }
    
    override func viewDidLayoutSubviews() {
        
        // Pass the page control through the collection view
        collectionView.controller?.pageControl = pageControl
        
        // Show or Hide the page control
        showHidePageControl()
        
        // Adjust Paging based the portrait and landscape mode
        adjustPaging()
        
        // Adjust collection view cell
        collectionView.adjustCellSize()
        collectionView.reloadData()
        
    }
    
    func showHidePageControl() {
        
        // Portrait mode
        if UIDevice.current.orientation.isPortrait {
            pageControl.setVisible(state: true, with: 37)
        }
        // Landscape mode
        else {
            pageControl.setVisible(state: false, with: 10)
        }
    }
    
    /**
        Enables the paging in portrait mode and disables the paging in landscape mode
     */
    func adjustPaging() {
        
        if UIDevice.current.orientation.isPortrait {
            collectionView.isPagingEnabled = true
        }
        else {
            collectionView.isPagingEnabled = false
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Identifier.AddIssueTableViewControllerSegue, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the current project to the Add Issue View Controller
        if segue.identifier == Identifier.AddIssueTableViewControllerSegue {
            
            let navigationController = segue.destination as! UINavigationController
            let addIssueTableViewController =  navigationController.topViewController as! IssueDetailTableViewController
            
            addIssueTableViewController.initView(with: project, issueType: IssueTypeController.shared.default(), priority: PriorityController.shared.default(),startDate: Date(), status: board?.columns.first?.status, delegate: self)
            
        }
    }
    
    
}

// MARK: - Orientation Changes

extension BoardViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("View will transition")
                
        // Adjusts the paging of the collection view
        adjustPaging()
        
        // Show or hide the page control
        showHidePageControl()

        // Reload the collection data when users change the orientation
        // Portait/Landscape mode
        // collectionView.reloadData()
        
    }
    
}

// MARK: - Add Issue Delegate

extension BoardViewController: IssueDetailDelegate {
    func didModidyIssue(issue: Issue) {
        // Do something here
    }
    
    
    func didAddIssue(with issue: Issue) {
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
    }
    private typealias S = SegueIdentifier
}
