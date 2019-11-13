//
//  ViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet var columnTableViewController: ColumnTableViewController!
    
    override func viewDidLoad() {
        print("Board View Controller: View Did Load")
    
    }

}

extension BoardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColumnCollectionViewCell
        print("Collection index path: \(indexPath)")
        cell.tableView.dataSource = columnTableViewController
        cell.tableView.delegate = columnTableViewController
        
        columnTableViewController?.tableView(reloadAt: indexPath)
        
        return cell
    }
    
}


