//
//  IssueCollectionView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/26/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueCollectionView: UICollectionView {
    
    var controller: IssueCollectionController?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        let layout = IssueCollectionViewFlowLayout()
//
//        controller = IssueCollectionController(collectionViewLayout: layout)
//        delegate = controller
//        dataSource = controller
//        controller?.collectionView = self
        
        // Register custom cell for UICollectionView
//        let nib = UINib(nibName: Identifier.IssueCollectionViewCell, bundle: .main)
//        register(nib, forCellWithReuseIdentifier: Identifier.IssueCollectionViewCell)
        
    }
    
    /**
     Adjust the cell's width and height to fit the collection view frame
     */
    func adjustCellSize() {
        
        var width: CGFloat = 0.0
        let height: CGFloat = frame.height
        
        // Landscape mode
        if UIDevice.current.orientation.isLandscape {
            width = UIScreen.main.bounds.width/2 - 30
           
        }
        // Portrait mode
        else {
             width = UIScreen.main.bounds.width - 40
        }
        
        if let flowLayout = collectionViewLayout as? IssueCollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: width, height: height )
        }
        
    }
}
