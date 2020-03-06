//
//  DeleteZoneCollectionView+DropDelegate.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 3/4/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

extension DeleteZoneCollectionView: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let item = coordinator.items.first,
            let dragItem = item.dragItem.localObject as? DragAttachmentItem else { return }
    
        let sourceCollectionView = dragItem.collectionView
        let indexPath = dragItem.indexPath
        
        do{
            try dragItem.attachment.remove()
        }catch { print(error) ; return }
        
        // Delete the attachemnt in the collection view
        sourceCollectionView.deleteItems(at: [indexPath])
        // Refresh the number of attachments
        let topVc = UIApplication.getTopViewController() as? IssueDetailTableViewController
        topVc?.refreshNumberOfAttachments()
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        self.backgroundView = self.imageForDeleteZone(isActive: false)
        self.backgroundColor = .none
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
        self.backgroundView = self.imageForDeleteZone(isActive: true)
        self.backgroundColor = .redCircleColor
        self.layer.cornerRadius = 50
        self.clipsToBounds = true
    }
    
}
