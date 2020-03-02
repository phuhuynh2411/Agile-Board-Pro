//
//  BColumnCollectionViewFlowLayout.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/25/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class BColumnCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        scrollDirection = .horizontal
        minimumLineSpacing = 10
        minimumLineSpacing = 10
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        context.contentSizeAdjustment = CGSize(width: 30, height: 30)
    }
    
}
