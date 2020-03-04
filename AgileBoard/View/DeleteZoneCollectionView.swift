//
//  DeleteZoneCollectionView.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 3/4/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class DeleteZoneCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 100, height: 100)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        
        // Setup collection view
        self.dragInteractionEnabled = true
        self.dropDelegate = self
        
        self.backgroundColor = .none
        self.backgroundView = imageForDeleteZone(isActive: false)
        
        guard let topVC = UIApplication.getTopViewController() as? IssueDetailTableViewController,
                let toolbar = topVC.navigationController?.toolbar  else { return }
        
        let mainView = topVC.view
        mainView?.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.bottomAnchor.constraint(equalTo: toolbar.topAnchor, constant: -16).isActive = true
        self.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor).isActive = true
        
        // Redraw the layout
        topVC.view.layoutIfNeeded()
        
        // Start animating
        self.startAnimating()
    }
    
    internal func imageForDeleteZone(isActive: Bool) -> UIImageView {
        
        let imageName = isActive ? "ic_delete_active" : "ic_delete"
        let deleteImageView = UIImageView()
        //deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.image = UIImage(named: imageName)
        deleteImageView.contentMode = .center
        
        return deleteImageView
    }
    
    func startAnimating() {
        // If the table view is being animated, do nothing and return.
        guard self.layer.animationKeys() == nil else { return }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 10))
            self.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi + 10))
        }) { (complete) in
        }
    }
    
    func delete() {
        self.removeFromSuperview()
    }
}
