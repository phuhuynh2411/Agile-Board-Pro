//
//  TopAlignedCollectionViewFlowLayout.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/18/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout
{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        if let attrs = super.layoutAttributesForElements(in: rect)
        {
            var baseline: CGFloat = -2
            var sameLineElements = [UICollectionViewLayoutAttributes]()
            for element in attrs
            {
                if element.representedElementCategory == .cell
                {
                    let frame = element.frame
                    let centerY = frame.midY
                    if abs(centerY - baseline) > 1
                    {
                        baseline = centerY
                        TopAlignedCollectionViewFlowLayout.alignToTopForSameLineElements(sameLineElements: sameLineElements)
                        sameLineElements.removeAll()
                    }
                    sameLineElements.append(element)
                }
            }
            TopAlignedCollectionViewFlowLayout.alignToTopForSameLineElements(sameLineElements: sameLineElements) // align one more time for the last line
            self.scrollDirection = .horizontal
            return attrs
        }
        return nil
    }

    private class func alignToTopForSameLineElements(sameLineElements: [UICollectionViewLayoutAttributes])
    {
        if sameLineElements.count < 1
        {
            return
        }
        let sorted = sameLineElements.sorted { ( obj1: UICollectionViewLayoutAttributes , obj2: UICollectionViewLayoutAttributes ) -> Bool in
            
            let height1 = obj1.frame.size.height
            let height2 = obj2.frame.size.height
            let delta = height1 - height2
            return delta <= 0

        }
        
        if let tallest = sorted.last
        {
            for obj in sameLineElements
            {
                obj.frame = obj.frame.offsetBy(dx: 0, dy: tallest.frame.origin.y - obj.frame.origin.y)
            }
        }
    }
}
