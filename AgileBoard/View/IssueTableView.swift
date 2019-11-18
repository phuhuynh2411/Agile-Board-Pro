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
    
    var visibleCellHeight: CGFloat?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
    
}
