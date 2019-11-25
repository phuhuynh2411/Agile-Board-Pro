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
        
        // Set the number of pages for the page control
        let columns = project?.boards.first?.columns
        self.pageControl.numberOfPages = columns?.count ?? 0
        
        // Remove navigation border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        // Register custom cell for UICollectionView
        let nib = UINib(nibName: Identifier.IssueCollectionViewCell, bundle: .main)
        issueCollectionView.register(nib, forCellWithReuseIdentifier: Identifier.IssueCollectionViewCell)
                
    }
    
    override func viewDidLayoutSubviews() {
        
        // Auto calculate the collecition view cell's width and height
        setCellSize()
        
        // Show or Hide the page control
        showHidePageControl()
        
    }
    
    ///
    /// Set the collection view cell's width and height
    ///
    func setCellSize() {
        
        let frame = issueCollectionView.frame
        var width: CGFloat = 0.0
        let height: CGFloat = frame.height
        
        // Portrait mode
        if UIDevice.current.orientation.isPortrait {
            width = UIScreen.main.bounds.width - 40
        }
            // Landscape mode
        else {
            width = UIScreen.main.bounds.height - 40
        }
        
        if let flowLayout = issueCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: width, height: height )
        }
        
    }
    
    ///
    /// Show/hide the page control
    /// Hide the page control if the orientation is Landscape
    /// Show the page control if the orientation is Portrait
    ///
    func showHidePageControl() {
        // Portrait mode
        if UIDevice.current.orientation.isPortrait {
            pageControl.isHidden = false
        }
        // Landscape mode
        else {
            pageControl.isHidden = true
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
        cell.countLabel.text = "\(issues!.count)"
        
        // Make the cell fit its content
        cell.setTableViewInitialHeight()
        cell.issueTableView.makeCellFitTableHeight(animated: false)
                        
        return cell
    }
    
}

// MARK: - Collection Delegate

extension BoardViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Calculate the current page number based on the scroll view offset
//        let pageWidth = scrollView.frame.size.width
//        let pageNumber: Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
//        pageControl.currentPage = pageNumber
        
    }
    
}

// MARK: - Orientation Changes

extension BoardViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Reload the collection data when users change the orientation
        // Portait/Landscape mode
        issueCollectionView.reloadData()
        
    }
    
}

// MARK: - UIScrollViewDelegate

extension BoardViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Re-calculate the paging
        let pageWidth = scrollView.frame.size.width
        let pageNumber: Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        let newX = CGFloat(pageNumber) * pageWidth - 30
        
        let rect = CGRect(x: newX, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.scrollRectToVisible(rect, animated: true)
        
        // Update the page number
        pageControl.currentPage = pageNumber
        
    }
}
