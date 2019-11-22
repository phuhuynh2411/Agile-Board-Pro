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
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var issueCollectionView: UICollectionView!
    
    // Issue table view controller
    @IBOutlet var issueTableViewController: IssueTableViewController!
    
    // Project
    var project: Project?
    
    override func viewDidLoad() {
        
        // Load project sample data
        project = ProjectManager.loadProjectSampleData()
        
        // Get the default Realm
        let realm = try! Realm()
        
        
        // Clean the previous data
        try! realm.write {
            realm.deleteAll()
        }
        
        // Add th project to realm inside a transaction
        try! realm.write {
            realm.add(project!)
        }
        
        // Set the number of pages for the page control
        let columns = project?.boards.first?.columns
        self.pageControl.numberOfPages = columns!.count
        
        // Remove navigation border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        // Register custom cell for UICollectionView
        let nib = UINib(nibName: Identifier.IssueCollectionViewCell, bundle: .main)
        issueCollectionView.register(nib, forCellWithReuseIdentifier: Identifier.IssueCollectionViewCell)
                
    }
    
    override func viewDidLayoutSubviews() {
        
        setCellSize()
        
    }
    
    func setCellSize() {
        
        if let flowLayout = issueCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let frame = issueCollectionView.frame
            
            flowLayout.itemSize = CGSize(width: frame.width - 40, height: frame.height )
            
        }
    }
    
    func makeCellFitTableHeight(cell: IssueCollectionViewCell) {
        
        guard cell.cellIsFit == false else { return }
        
        cell.issueTableView.tableHeightConstraint.constant = cell.tableEstimatedHeight
               
        UIView.animate(withDuration: 0, animations: {
            cell.issueTableView.layoutIfNeeded()
            }) { (complete) in
                var heightOfTableView: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = cell.issueTableView.visibleCells
                for cell in cells {
                    heightOfTableView += cell.frame.height
                }
                
                cell.cellIsFit = true

                heightOfTableView = heightOfTableView < cell.tableEstimatedHeight ? heightOfTableView : cell.tableEstimatedHeight
                
                cell.issueTableView.tableHeightConstraint.constant = heightOfTableView
                
                cell.layoutIfNeeded()
                
        }
        
    }

}

// MARK: - Collection Data Source

extension BoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let columns = project?.boards.first?.columns
        
        return columns?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.IssueCollectionViewCell, for: indexPath) as! IssueCollectionViewCell
        
        // The columns of the first board
        let columns = project?.boards.first?.columns
        let status = columns?[indexPath.row].status
        
        // Get all issues by status
        let issues = project?.issues.filter("status = %@", status!)
    
        
        cell.setUpTableView(issueList: issues!, column: columns?[indexPath.row])
        cell.headerLabel.text = columns?[indexPath.row].name
        
        // Make the cell fit its content
        cell.setTableViewInitialHeight()
        cell.issueTableView.makeCellFitTableHeight(animated: false)
        
        return cell
    }
    
}
