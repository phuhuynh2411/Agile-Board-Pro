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
    
    let dataList1 = [
        Issue(summary: "Sed posuere consectetur est at lobortis."),
        Issue(summary: "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."),
        Issue(summary: "Aenean lacinia bibendum nulla sed consectetur.")
    ]
    let dataList2 = [
           Issue(summary: "Sed posuere consectetur est at lobortis."),
           Issue(summary: "Morbi leo risus, porta ac consectetur ac, vestibulum at eros."),
           Issue(summary: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet.")
    ]
    let dataList3 = [
           Issue(summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
           Issue(summary: "Donec ullamcorper nulla non metus auctor fringilla."),
           Issue(summary: "Donec sed odio dui.")
    ]
    var collectionData = [[Issue]]()
    
    // MARK: - Outlets
    
    @IBOutlet var columnTableViewController: ColumnTableViewController!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        
        collectionData.append(dataList1)
        collectionData.append(dataList2)
        collectionData.append(dataList3)
        
        // Set the number of pages for the page control
        self.pageControl.numberOfPages = collectionData.count
        
    }

}
// MARK: - Collection Data Source

extension BoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColumnCollectionViewCell
        
        // Set the data source and the delegate to the table view
        cell.tableView.dataSource = columnTableViewController
        cell.tableView.delegate = columnTableViewController
        
        // Initilize data for the table view
        columnTableViewController?.tableView(reloadDataAt: indexPath, withIssues: collectionData[indexPath.row])
        
        return cell
    }
    
    
}

// MARK: - Collection View Delegate
extension BoardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Refresh the current page for the page control
        self.pageControl.currentPage = indexPath.section
        
        print("View will display")
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}
