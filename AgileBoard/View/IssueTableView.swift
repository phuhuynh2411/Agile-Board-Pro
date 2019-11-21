//
//  ColumnTableView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueTableView: UITableView{
    
    var initialCenter = CGPoint()
    var panGesture: UIPanGestureRecognizer?
        
    // Table view initial height and minimum height
    var initialHeight: CGFloat?
    var minHeight: CGFloat?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Enable drag operation
        self.dragInteractionEnabled = true
        
    }
    
    var tableHeightConstraint: NSLayoutConstraint {
        return self.constraints.first { $0.identifier == "tableHeightConstraint" }!
    }
    
    func addPadGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(gestureRecognizer:)))
        self.addGestureRecognizer(panGesture!)
    }
    
    func removePadGesture() {
        self.removeGestureRecognizer(panGesture!)
    }
    
    @objc func panAction(gestureRecognizer: UIPanGestureRecognizer) {
        print("Pan gesture recognizer started!")
        
        guard gestureRecognizer.view != nil else {return}
       let piece = gestureRecognizer.view!
   
       // Get the changes in the X and Y directions relative to
       // the superview's coordinate space.
       let translation = gestureRecognizer.translation(in: piece)
       if gestureRecognizer.state == .began {
          // Save the view's original position.
          //self.initialCenter = piece.center
       }
          // Update the position for the .began, .changed, and .ended states
       if gestureRecognizer.state != .cancelled {
           
           if gestureRecognizer.verticalDirection(target: piece) == .Down || gestureRecognizer.verticalDirection(target: piece) == .Up {
               // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: piece.center.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
            //gestureRecognizer.setTranslation(CGPoint.zero, in: piece)
            
           }
            if gestureRecognizer.horizontalDirection(target: piece) == .Right {
               print("Right Pan")
                //removePadGesture()
           }
           if gestureRecognizer.horizontalDirection(target: piece) == .Left {
               print("Left Pan")
           }
           
         
       }
       else {
          // On cancellation, return the piece to its original location.
          //piece.center = initialCenter
       }
    }
    
    ///
    /// Make the collection cell fit the table view height
    ///
    func makeCellFitTableHeight(animated:Bool = false) {
        
        guard let initialHeight = self.initialHeight else { return }
        
        UIView.animate(withDuration: 0, animations: {
            self.layoutIfNeeded()
            }) { (complete) in
                var visibelCellHeight: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = self.visibleCells
                for cell in cells {
                    visibelCellHeight += cell.frame.height
                }
                
                visibelCellHeight = visibelCellHeight < initialHeight ? visibelCellHeight : initialHeight
                
                self.tableHeightConstraint.constant = visibelCellHeight
                
                if animated {
                    UIView.animate(withDuration: 0.5) {
                        self.superview?.layoutIfNeeded()
                    }
                }
                else {
                    self.superview?.layoutIfNeeded()
                }
                
                
                print("Visible cell height \(visibelCellHeight)")
        }
        
    }
    
    ///
    /// Increase the table height's constraint
    ///
    func increaseTableHeight(with height: CGFloat) {
        
        var newHeight = tableHeightConstraint.constant + height
        newHeight = newHeight < initialHeight! ? newHeight : initialHeight!
        
        tableHeightConstraint.constant = newHeight
        
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    ///
    /// Set inital height for the table view
    ///
    func setInitialHeightConstraint(height: CGFloat) {
        
        tableHeightConstraint.constant = height
        initialHeight = height
        
    }
    
}
