//
//  IssueCollectionViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/26/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class IssueCollectionController: NSObject {
    
    var project: Project?
        
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
        
        let columns = project?.selectedBoard?.columns
        return columns?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.IssueCollectionViewCell, for: indexPath) as! IssueCollectionViewCell

        update(cell: cell, at: indexPath)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension IssueCollectionController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        return proposedContentOffset
    }
    
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
        
        print("Visible rect \(rect)")
        print("Content off set \(scrollView.contentOffset)")
        
        //scrollView.contentOffset = CGPoint(x: newX, y: 0)
        
        // Update the page number
        pageControl?.currentPage = pageNumber
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItem(collectionView)
    }
        
    private func sizeForItem(_ collectionView: UICollectionView) ->CGSize {
        // Landscape mode
        let width = UIDevice.current.orientation.isLandscape ? collectionView.frame.width/2 - 30
            : collectionView.frame.width - 40
        
        let height:CGFloat = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let issueCell = cell as! IssueCollectionViewCell
        
        // Reload the table view data
        issueCell.issueTableView.reloadData()
        
        // Make the table view fit the visisble cell's height
        let maxHeight = issueCell.frame.height - issueCell.headerFooterHeight
        issueCell.issueTableView.maxHeight = maxHeight
        issueCell.issueTableView.fitVisibleCellHeight(maxHeight: maxHeight, minHeight: 40, animated: false)
    }
    
}

// MARK: - Collection View Cell

extension IssueCollectionController {
    
    func update(cell: IssueCollectionViewCell, at indexPath: IndexPath) {
        
        // The columns of the first board
        let columns = project?.selectedBoard?.columns
        let status = columns?[indexPath.row].status
    
        cell.headerLabel.text = status?.name
        if let issues = project?.issues, let column = columns?[indexPath.row] {
              cell.tableViewController?.dataForTableView(with: issues, and: column)
        }
        
    }
    
    
}
