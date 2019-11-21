//
//  ViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    // MARK: - Properties
    
    var dataList1: NSMutableArray = [
        Issue(summary: "Sed posuere consectetur est at lobortis."),
        Issue(summary: "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."),
        Issue(summary: "Aenean lacinia bibendum nulla sed consectetur."),
        Issue(summary: "Sed posuere consectetur est at lobortis."),
        Issue(summary: "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."),
        Issue(summary: "Aenean lacinia bibendum nulla sed consectetur."),
        Issue(summary: "Sed posuere consectetur est at lobortis."),
        Issue(summary: "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."),
        Issue(summary: "Aenean lacinia bibendum nulla sed consectetur."),
        Issue(summary: "Sed posuere consectetur est at lobortis."),
        Issue(summary: "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."),
        Issue(summary: "Aenean lacinia bibendum nulla sed consectetur.")
    ]
    
    var dataList2: NSMutableArray = [
           Issue(summary: "Sed posuere consectetur est at lobortis."),
           Issue(summary: "Morbi leo risus, porta ac consectetur ac, vestibulum at eros."),
           Issue(summary: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet.")
    ]
    var dataList3: NSMutableArray = [
           Issue(summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
           Issue(summary: "Donec ullamcorper nulla non metus auctor fringilla."),
           Issue(summary: "Donec sed odio dui."),
           Issue(summary: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet.")
    ]
    var collectionData = NSMutableArray()
    
    // MARK: - Outlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var issueCollectionView: UICollectionView!
    
    // Issue table view controller
    @IBOutlet var issueTableViewController: IssueTableViewController!
    
    
    override func viewDidLoad() {
                
        collectionData.add(dataList1)
        collectionData.add(dataList2)
        collectionData.add(dataList3)
        
        // Set the number of pages for the page control
        self.pageControl.numberOfPages = collectionData.count
        
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
    
    func fitTheCell(cell: IssueCollectionViewCell) {
        
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
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.IssueCollectionViewCell, for: indexPath) as! IssueCollectionViewCell
        
        cell.issueTableViewController?.issueList = collectionData[indexPath.row] as? NSMutableArray
        
        // Make the cell fit its content
        fitTheCell(cell: cell)
        
        return cell
    }
    
}
