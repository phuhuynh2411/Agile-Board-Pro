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
    
    // The number of attachments
    var numberLabel: UILabel?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        controller = AttachmentCollectionViewController(collectionViewLayout: collectionViewLayout)
        self.dataSource = controller
        self.delegate = controller
        controller?.collectionView = self
        
        // Enable dragging
        dragInteractionEnabled = true
        self.dragDelegate = controller        
    }
}
