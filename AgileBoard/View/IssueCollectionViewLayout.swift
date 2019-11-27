//
//  IssueCollectionViewLayout.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/19/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    func commonInit() {
        
        let screenSize = UIScreen.main.bounds
        itemSize = CGSize(width: screenSize.width - 40, height: screenSize.height - 200)
        scrollDirection = .horizontal
        minimumInteritemSpacing = 10.0
        minimumLineSpacing = 10.0
        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
