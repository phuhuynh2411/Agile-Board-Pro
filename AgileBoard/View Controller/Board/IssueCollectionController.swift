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
    
    var scrollVelocity: CGPoint?
        
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape else { return }
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        self.scrollVelocity = velocity
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape,
            let velocity = self.scrollVelocity else { return }
        
        let pageWidth = scrollView.frame.size.width
        var pageNumber: Int = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth = layout.itemSize.width
        let spacing = layout.minimumLineSpacing
        let numberOfCells = Int(pageWidth/(cellWidth + spacing))
        
        let totalCellWidth = CGFloat(numberOfCells) * cellWidth
        let totalSpacing = CGFloat(numberOfCells ) * spacing
        
        let oldX = CGFloat(pageNumber) * (totalSpacing + totalCellWidth)

        let segueX = cellWidth/2
        pageNumber = isScrollToLeft(scrollView) ? pageNumber - 1 : pageNumber + 1
        
        // Scroll left
        if isScrollToLeft(scrollView), !(scrollView.contentOffset.x < oldX - segueX), abs(velocity.x) < 0.5 {
            scrollTo(x: oldX, scrollView) ; return
        } else if !(scrollView.contentOffset.x > oldX + segueX), abs(velocity.x) < 0.5 {
            scrollTo(x: oldX, scrollView) ; return
        } else {
            let newX = CGFloat(pageNumber) * (totalSpacing + totalCellWidth)
            self.scrollTo(x: newX, scrollView)
        }
        // Update the page number
        pageControl?.currentPage = pageNumber
    }
    
    private func isScrollToLeft(_ scrollView: UIScrollView) -> Bool {
        return scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0
    }
    
    private func scrollTo(x: CGFloat, _ scrollView: UIScrollView) {
        let rect = CGRect(x: x, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItem(collectionView)
    }
        
    private func sizeForItem(_ collectionView: UICollectionView) ->CGSize {
        // Landscape mode
        let width = UIApplication.shared.statusBarOrientation.isLandscape ? collectionView.frame.width/2 - 30
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
