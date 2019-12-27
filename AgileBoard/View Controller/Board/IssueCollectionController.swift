//
//  IssueCollectionViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/26/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueCollectionController: NSObject {
    
    var project: Project?
    
    var selectedBoard: Board?
    
    var pageControl: IssuePageControlView?
    
    var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: Identifier.IssueCollectionViewCell, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: Identifier.IssueCollectionViewCell)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDatasource

extension IssueCollectionController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let columns = selectedBoard?.columns
        return columns?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.IssueCollectionViewCell, for: indexPath) as! IssueCollectionViewCell

        update(cell: cell, at: indexPath)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension IssueCollectionController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape else { return }
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape else { return }
        
        let pageWidth = scrollView.frame.size.width
        var pageNumber: Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth = layout.itemSize.width
        let spacing = layout.minimumLineSpacing
        let numberOfCells = Int(pageWidth/(cellWidth + spacing))
        
        let totalCellWidth = CGFloat(numberOfCells) * cellWidth
        let totalSpacing = CGFloat(numberOfCells ) * spacing

        // Scroll left
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
            pageNumber -= 1
        }
        // Scroll right
        else {
            pageNumber += 1
        }
        let newX = CGFloat(pageNumber) * (totalSpacing + totalCellWidth)
        
        let rect = CGRect(x: newX, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.scrollRectToVisible(rect, animated: true)
        
        // Update the page number
        pageControl?.currentPage = pageNumber
        
    }
}

// MARK: - Collection View Cell

extension IssueCollectionController {
    
    func update(cell: IssueCollectionViewCell, at indexPath: IndexPath) {
        
        // The columns of the first board
        let columns = selectedBoard?.columns
        let status = columns?[indexPath.row].status
        
        // Get all issues by status
        let issues = project?.issues.filter("status = %@", status!)
    
        cell.headerLabel.text = status?.name
        
        cell.tableViewController?.dataForTableView(with: issues, and: columns![indexPath.row])
        
        // Reload the table view data
        cell.issueTableView.reloadData()
        
        // Make the table view fit the visisble cell's height
        let maxHeight = cell.frame.height - cell.headerFooterHeight
        cell.issueTableView.maxHeight = maxHeight
        cell.issueTableView.fitVisibleCellHeight(maxHeight: maxHeight, minHeight: 40, animated: false)
    }
    
}