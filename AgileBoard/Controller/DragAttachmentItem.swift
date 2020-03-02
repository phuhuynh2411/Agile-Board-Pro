//
//  DragAttachmentItem.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/11/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import UIKit

class DragAttachmentItem {
    
    var collectionView: UICollectionView
    var attachment: Attachment
    var indexPath: IndexPath
    
    init(attachment: Attachment, collectionView: UICollectionView, indexPath: IndexPath) {
        self.attachment = attachment
        self.collectionView = collectionView
        self.indexPath = indexPath
    }
}
