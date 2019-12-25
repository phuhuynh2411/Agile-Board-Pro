//
//  BoardDetailColumnViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class BoardDetailColumnViewController: UIViewController {

    var columns: List<Column>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - UICollection View Datasource

extension BoardDetailColumnViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4//columns?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColumnCell", for: indexPath) as! BColumnColumnCollectionViewCell
        
        // Make the cell round
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        // Update column number
        cell.numberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    // MARK: - View for collection header and footer
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var cellIdentifier = ""
        var viewType = ""
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            cellIdentifier = "FooterCell"
            viewType = UICollectionView.elementKindSectionFooter
            break
        default:
            print("Undefine view")
        }
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: viewType, withReuseIdentifier: cellIdentifier, for: indexPath) as! BColumnCollectionReusableView
        
        var number = columns?.count ?? 1
        number = number == 1 ? 1 : number + 1
        
        cell.titleLabel.text = "COLUMN \(number)"
        cell.placeholderBackground.layer.cornerRadius = 10.0
        cell.placeholderBackground.clipsToBounds = true
        
        // Make the cell round
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        // Adjusts the footer's size to be equal the item size
        // let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // cell.frame.size = layout.itemSize
                
        return cell
    }
    
    
}

// MARK: - UICollection View Delegate

extension BoardDetailColumnViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItem(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
                
        return sizeForItem(collectionView)
    }
    
    private func sizeForItem(_ collectionView: UICollectionView) ->CGSize {
        
        // Landscape mode
        let width = UIDevice.current.orientation.isLandscape ? collectionView.frame.width/2 - 5
            : collectionView.frame.width
           
        let insetTopBottom = collectionView.contentInset.top + collectionView.contentInset.bottom
        let height = collectionView.frame.height - insetTopBottom
        
        return CGSize(width: width, height: height)
        
    }
    
}

