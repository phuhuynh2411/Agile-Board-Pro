//
//  AttachmentCollectionViewFlowLayout.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/5/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class AttachmentCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    func commonInit() {
        
        itemSize = CGSize(width: 50, height: 50)
        scrollDirection = .horizontal
        minimumInteritemSpacing = 10.0
        minimumLineSpacing = 10.0
        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
    }
}
