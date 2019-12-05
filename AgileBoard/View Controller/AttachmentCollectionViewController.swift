//
//  AttachmentCollectionViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/5/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class AttachmentCollectionViewController: UICollectionViewController {
    
    // MARK: Properities
    
    var attachmentList: Results<Attachment>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AttachmentCollectionViewCell
        
        let attachment = attachmentList?[indexPath.row]
        if let imageName = attachment?.url {
            cell.attachmentImageView.image = UIImage(named: imageName)
        }
        
        return cell
    }

}
