//
//  IconCollectionViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/29/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

protocol SelectIconDelegate {
    func didSelectIcon(icon: ProjectIcon?)
}

class IconCollectionViewController: UICollectionViewController {
    
    var icons: Results<ProjectIcon>?
    var selectedIcon: ProjectIcon?
    var delegate: SelectIconDelegate?

    let realm = AppDataController.shared.realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        icons = realm?.objects(ProjectIcon.self)
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IconCollectionViewCell
            
        let icon = icons?[indexPath.row]
        if let iconName = icon?.name {
            cell.iconImageView.image = UIImage(named: iconName)
        }
        
        
        // Check whether to show the checkmark
        if icon?.id == selectedIcon?.id {
            cell.checkImageView.isHidden = false
        }
        else {
            cell.checkImageView.isHidden = true
        }
    
        return cell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let icon = icons?[indexPath.row]
        
        delegate?.didSelectIcon(icon: icon)
            
        navigationController?.popViewController(animated: true)
    }

}
