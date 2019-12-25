//
//  BoardDetailStatusViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class BoardDetailStatusViewController: UIViewController {
    
    var statuses: List<Status>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UICollection View Datasource

extension BoardDetailStatusViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusCell", for: indexPath) as! BStatusCollectionViewCell
        
        let status = statuses?[indexPath.row]
        cell.nameLabel.text = status?.name
        if let hexColor = status?.color?.hexColor {
            let uiColor = UIColor(hexString: hexColor)
            cell.backgroundColor = uiColor
            cell.nameLabel.textColor = UIColor().textColor(bgColor: uiColor)
        }
        
        // Make the cell round
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - View for collection header and footer
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var cellIdentifier = ""
        var viewType = ""
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            cellIdentifier = "HeaderCell"
            viewType = UICollectionView.elementKindSectionHeader
            break
        default:
            print("Undefine view")
        }
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: viewType, withReuseIdentifier: cellIdentifier, for: indexPath) as! BStatusHeaderCell
        
        cell.numberLabel.text = "\(statuses?.count ?? 0)"
                
        return cell
    }
    
}

// MARK: - UICollection View Delegate

extension BoardDetailStatusViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItem(collectionView)
    }
    
    private func sizeForItem(_ collectionView: UICollectionView) ->CGSize {
        
        // Landscape mode
        var width = UIDevice.current.orientation.isLandscape ? collectionView.frame.width/2
            : collectionView.frame.width
        width -= 20

        let height:CGFloat = 44
        
        return CGSize(width: width, height: height)
        
    }
}

// MARK: - UICollectionViewDragDelegate

extension BoardDetailStatusViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let status = statuses?[indexPath.row]
        dragItem.localObject = (status: status, collectionView: collectionView, indexPath: indexPath)
        
    
        return [dragItem]

    }
    
    
}

// MARK: - UICollectionViewDropDelegate

extension BoardDetailStatusViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let item = coordinator.items.first else { return }
        
        if let (column, srcCollectionView, srcIndexPath) = item.dragItem.localObject as? (Column, UICollectionView, IndexPath),
            let status = column.status {
            
            statuses?.append(status)
            collectionView.reloadData()
            
            // Remove column at source collection view
            // Remove the status at the source collection view
            if let datasource = srcCollectionView.dataSource as? BoardDetailColumnViewController,
                let srcColumns = datasource.columns {
                
                srcColumns.remove(at: srcIndexPath.row)
                srcCollectionView.reloadData()
                //srcCollectionView.collectionViewLayout.invalidateLayout()
            }
            
        }
        
    }
    
}
