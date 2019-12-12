//
//  DueDatePresentationController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import UIKit

class HalfScreenPresentationController: UIPresentationController{
    
    var presentedViewHeight: CGFloat?
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
//    override var frameOfPresentedViewInContainerView: CGRect{
//        return frame != nil ? frame! : CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height/2), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height/2))
//    }
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.3
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in

        })
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        //presentedView!.layer.cornerRadius = 10
       
    }
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        //self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
        
        presentedView?.translatesAutoresizingMaskIntoConstraints = false
        
        presentedView?.heightAnchor.constraint(equalToConstant: presentedViewHeight ?? 200).isActive = true
        //presentedView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        presentedView?.bottomAnchor.constraint(equalToSystemSpacingBelow: containerView!.bottomAnchor, multiplier: 0).isActive = true
        presentedView?.centerXAnchor.constraint(equalTo: containerView!.centerXAnchor).isActive = true
        presentedView?.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView!.leadingAnchor, multiplier: 0).isActive = true
        presentedView?.trailingAnchor.constraint(equalToSystemSpacingAfter: containerView!.trailingAnchor, multiplier: 0).isActive = true
        
        containerView?.layoutIfNeeded()
    }
}
