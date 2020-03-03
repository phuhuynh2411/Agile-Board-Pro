//
//  DeleteZoneTableView.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 3/3/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class DeleteZoneTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundView = self.imageForDeleteZone(isActive: false)
        self.backgroundColor = .none
        self.dropDelegate = self
        self.dragInteractionEnabled = true
        self.separatorStyle = .none
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        guard let topVc = UIApplication.getTopViewController() as? BoardViewController,
            let view = topVc.view else { return }
        
        view.addSubview(self)
        
        self.bottomAnchor.constraint(equalTo: topVc.pageControl.bottomAnchor, constant: -16).isActive = true
        self.centerXAnchor.constraint(equalTo: topVc.pageControl.centerXAnchor).isActive = true
        
        // Redraw the layout
        topVc.view.layoutIfNeeded()
    }
    
    func delete() {
        self.removeFromSuperview()
    }
    
    internal func imageForDeleteZone(isActive: Bool) -> UIImageView {
        
        let imageName = isActive ? "ic_delete_active" : "ic_delete"
        let deleteImageView = UIImageView()
        //deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.image = UIImage(named: imageName)
        deleteImageView.contentMode = .bottom
        
        return deleteImageView
    }
}
