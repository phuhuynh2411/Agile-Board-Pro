//
//  ColumnTableView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueTableView: UITableView{
    
    /// Dashed border
    private var shapeLayer: CAShapeLayer?
    
    /// Table view height constraint
    var heightConstraint: NSLayoutConstraint {
        self.constraints.first { $0.identifier == "heightConstraint" }!
    }
    
    /// The maximum height of the table view. It cannnot exceed this height
    var maxHeight: CGFloat?
    
    /// Number of issue label. Passed from the collection view cell
    var issueCountLabel: UILabel?
            
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Enable drag operation
        self.dragInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    /**
     Resize the table view height to fit the visible cell height
     - Parameters:
        -   animated: adjusts the height with an animation within 0.5 second.
        -   maxHeight: uses max height if the visible cell's height is greater than max height
        -   minHeight: A minimum height of the table view.
        -   full: resize the table height to the maximum height before fitting the height
     - Returns: Do not return any value
     */
    func fitVisibleCellHeight(maxHeight: CGFloat = 0, minHeight: CGFloat = 0, animated: Bool = false, full: Bool = true) {
        
        // If the maxHeight is equal zero, make sure that the default table view
        // maximum height was set up
        if maxHeight == 0, self.maxHeight == nil{
            fatalError("Need to set the maximum height for the table view")
        }
        
        // Use the table view maximum height if the maxHeight is 0
        let mHeight = maxHeight == 0 ? self.maxHeight! : maxHeight
        
        // Increase the table view to the max height before adjusting it to fit
        if full {
            heightConstraint.constant = mHeight
            self.layoutIfNeeded()
        }
                
        UIView.animate(withDuration: 0, animations: {
            self.layoutIfNeeded()
            }) { (complete) in
                var visibelCellHeight: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = self.visibleCells
                for cell in cells {
                    visibelCellHeight += cell.frame.height
                }
                
                visibelCellHeight = visibelCellHeight < mHeight ? visibelCellHeight : mHeight
                visibelCellHeight = visibelCellHeight < minHeight ? minHeight : visibelCellHeight
                
                self.heightConstraint.constant = visibelCellHeight
                
                if animated {
                    UIView.animate(withDuration: 0.5) {
                        self.superview?.layoutIfNeeded()
                    }
                }
                else {
                    self.superview?.layoutIfNeeded()
                }
        }
        
    }
    
    /**
     Increase table view's height
     - Parameters:
        - height: A height that will be added to the table view's height
        - animated: indicate whether adding an animation when increasing the table view's height. The default value is true.
     */
    func increaseHeight(with height: CGFloat, animated: Bool = true) {
        
        guard let maxHeight = self.maxHeight else {
            fatalError("Need to set the maximum height for the table view before increasing the height")
        }
        
        var newHeight = heightConstraint.constant + height
        newHeight = newHeight < maxHeight ? newHeight : maxHeight
        
        heightConstraint.constant = newHeight
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.superview?.layoutIfNeeded()
            }
        }
        else {
            self.superview?.layoutIfNeeded()
        }
        
    }
    
    /**
     Decrease the table view's height
     - Parameters:
        - height: the height that the table view height subtracts
        - minHeight: the minimum height of the table view after subtracting
        - animated: indicates whether adding an animation when descreasing the table view's height
     */
    func decreaseHeight(height: CGFloat, minHeight: CGFloat = 0, animated: Bool = true) {
        
        print("Current table height: \(heightConstraint.constant)")
        var newHeight = heightConstraint.constant - height
        newHeight = newHeight < minHeight ? minHeight : newHeight
        
        heightConstraint.constant = newHeight
        
        print("New Height \(newHeight)")
        print("Height: \(height)")
        print("Min Height: \(minHeight)")
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.superview?.layoutIfNeeded()
            }
        }
        else {
            self.superview?.layoutIfNeeded()
        }
    }
    
    /**
     Set table view height
     - Parameters:
        - height: table view height
        - animated: indicates whether adding an animation when increasing the table view's height. The default value is true.
     */
    func setHeight(height: CGFloat, animated: Bool = true) {
        
        heightConstraint.constant = height
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
}
