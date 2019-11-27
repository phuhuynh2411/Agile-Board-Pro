//
//  IssueCollectionViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/26/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueCollectionViewController: UICollectionViewController {
    
    var project: Project?
    
    var selectedBoard: Board?
    
    var pageControl: IssuePageControlView?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Collection Data Source

extension IssueCollectionViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let columns = project?.boards.first?.columns
        return columns?.count ?? 0
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.IssueCollectionViewCell, for: indexPath) as! IssueCollectionViewCell

        update(cell: cell, at: indexPath)
        
        return cell
    }
    
}

// MARK: - UIScrollViewDelegate

extension IssueCollectionViewController {
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape else { return }
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape else { return }
        
        // Re-calculate the paging
        let pageWidth = scrollView.frame.size.width
        let pageNumber: Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        let newX = CGFloat(pageNumber) * pageWidth - CGFloat(30 * pageNumber)
        
        let rect = CGRect(x: newX, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.scrollRectToVisible(rect, animated: true)
        
        // Update the page number
        pageControl?.currentPage = pageNumber
        
    }
}

// MARK: - Collection View Cell

extension IssueCollectionViewController {
    
    func update(cell: IssueCollectionViewCell, at indexPath: IndexPath) {
        
        // The columns of the first board
        let columns = project?.boards.first?.columns
        let status = columns?[indexPath.row].status
        
        // Get all issues by status
        let issues = project?.issues.filter("status = %@", status!)
    
        cell.headerLabel.text = columns?[indexPath.row].name
        // cell.countLabel.text = "\(issues!.count)"
        
        // Add data source for the table view
        let tableViewController = cell.issueTableView.controller
        tableViewController?.dataForTableView(with: issues, and: columns![indexPath.row])
        
        // Reload the table view data
        cell.issueTableView.reloadData()
        
        // Make the table view fit the visisble cell's height
        let maxHeight = cell.frame.height - cell.headerFooterHeight
        cell.issueTableView.maxHeight = maxHeight
        cell.issueTableView.fitVisibleCellHeight(maxHeight: maxHeight, minHeight: 40, animated: false)
    }
    
}
