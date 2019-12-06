//
//  AttachmentCollectionView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/5/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class AttachmentCollectionView: UICollectionView {
    
    var controller: AttachmentCollectionViewController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("Collection view was initiated.")
        
        controller = AttachmentCollectionViewController(collectionViewLayout: collectionViewLayout)
        self.dataSource = controller
        self.delegate = controller
        controller?.collectionView = self
        
    }
}
