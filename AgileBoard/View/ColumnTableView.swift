//
//  ColumnTableView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ColumnTableView: UITableView{
    
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//
//        print("Table view load")
//    }
//
    var initialCenter = CGPoint()
    var panGesture: UIPanGestureRecognizer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Make the table view rounded.
        self.layer.cornerRadius = 5.0
        
        // Add Pan Gesture Recognizer
        // addPadGesture()
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
