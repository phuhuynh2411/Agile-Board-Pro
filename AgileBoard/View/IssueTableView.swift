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
    fileprivate var shapeLayer: CAShapeLayer?
    
    /// Table View Controller
    var controller: IssueTableViewController?
    
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
        
        // Configure table view
        configureTableView()
        
    }
    
    func configureTableView() {
        
        // Initilize the issue table view controller
        controller = IssueTableViewController(style: .plain)
        controller?.tableView = self
        
        // Set data source and delegate to the table view
        dataSource = controller
        delegate = controller
        
        // Set table view drag and drop delegate
        dragDelegate = controller
        dropDelegate = controller
        
        let nib = UINib(nibName: Identifier.IssueTableViewCell, bundle: .main)
        register(nib, forCellReuseIdentifier: Identifier.IssueTableViewCell)
        
    }
    
    /**
     Resize the table view height to fit the visible cell height
     - Parameters:
        -   animated: adjusts the height with an animation within 0.5 second.
        -   maxHeight: uses max height if the visible cell's height is greater than max height
        -   minHeight: A minimum height of the table view.
     - Returns: Do not return any value
     */
    func fitVisibleCellHeight(maxHeight: CGFloat = 0, minHeight: CGFloat = 0, animated: Bool = false) {
        
        // If the maxHeight is equal zero, make sure that the default table view
        // maximum height was set up
        if maxHeight == 0, self.maxHeight == nil{
            fatalError("Need to set the maximum height for the table view")
        }
        
        // Use the table view maximum height if the maxHeight is 0
        let mHeight = maxHeight == 0 ? self.maxHeight! : maxHeight
        
        // Increase the table view to the max height before adjusting it to fit
        heightConstraint.constant = mHeight
        //self.layoutIfNeeded()
                
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
        
        var newHeight = heightConstraint.constant - height
        newHeight = newHeight < minHeight ? minHeight : newHeight
        
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
     Set table view height
     - Parameters:
        - height: table view height
        - animated: indicates whether adding an animation when increasing the table view's height. The default value is true.
     */
    func height(height: CGFloat, animated: Bool = true) {
        
        heightConstraint.constant = height
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    /**
     Add a dashed border rectangle onto the table view
     - Parameters:
        - frame: the frame in which the dashed border rectangle is drawed
     */
    func addDashedBorder(at frame: CGRect) {
        
        removeDashedBorder()
        
        // guard let cell = tableViewCell else { return }
        guard shapeLayer == nil else { return }

        let color = UIColor.lightGray.cgColor

        shapeLayer = CAShapeLayer()
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        shapeLayer?.bounds = shapeRect
        shapeLayer?.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.strokeColor = color
        shapeLayer?.lineWidth = 2.0
        shapeLayer?.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer?.lineDashPattern = [9,6]
        shapeLayer?.path = UIBezierPath(roundedRect: CGRect(x: frame.minX + 8, y: frame.minY + 4, width: shapeRect.width - 16, height: shapeRect.height - 8), cornerRadius: 7).cgPath

        self.layer.addSublayer(self.shapeLayer!)
        
    }
    
    /**
     Remove the dashed border rectangle on the table view
     */
    func removeDashedBorder() {
        
        if shapeLayer != nil {
            shapeLayer?.removeFromSuperlayer()
            shapeLayer = nil
        }
        
    }
    
}
