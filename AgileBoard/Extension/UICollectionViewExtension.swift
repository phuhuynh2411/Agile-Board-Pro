//
//  UICollectionViewExtension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 1/8/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    
    /**
     Reload collection view's visible items
     */
    public func reloadVisibleItems() {
        let visibleIndexPaths = self.visibleCells.enumerated().compactMap {
            return IndexPath(row: $0.0, section: 0)
        }
        self.reloadItems(at: visibleIndexPaths)
    }
    
    public func reloadHeader() {
        self.reloadSections(IndexSet(integer: 0))
    }
    
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }

}
