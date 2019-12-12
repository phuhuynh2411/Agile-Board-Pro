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
    
    var attachmentList: List<Attachment>?
    
    var topController = UIApplication.getTopViewController()
    
    var selectedAttachment: Attachment?
    
    var numberLabel: UILabel?
    
    var deleteZoneCollectionView: UICollectionView?

    // MARK: Init Methods
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
            
        //attachmentList = List<Attachment>()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: IB Actions
    
    @objc func addAttachment(sender: UIButton) {
        print("Add attachment pressed")
        
        let alert = UIAlertController(title: "", message: "Select the following options to add the attachments. Press OK if there is any message prompts out.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel pressed")
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.takePhoto()
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.selectPhoto()
        }
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        
       topController?.present(alert, animated: true, completion: nil)

    }
    
    // MARK: Helper Methods
    
    private func selectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
         imagePickerController.sourceType = .photoLibrary
        
        // Veriry the photo library
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The Photo Library is not available")
            return
        }
       topController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        print("Take photo")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
         
         // Veriry the photo library
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
             print("The Cammera is not available")
             return
         }
        topController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Navigation


    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = attachmentList?.count ?? 0
        // Update the number of attachments
        numberLabel?.text = "\(count)"
        
        // Add Inset right with 10 pt
        if count > 0 {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AttachmentCollectionViewCell
        
        let attachment = attachmentList?[indexPath.row]
        if let stringURL = attachment?.url {
            cell.attachmentImageView.image = UIImage.image(filePath: stringURL)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
        
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.addTarget(self, action: #selector(addAttachment(sender:)), for: .touchUpInside)
            }
        }
        
        return view
        
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Did select row at index path \(indexPath)")
        selectedAttachment = attachmentList?[indexPath.row]
        let nav = topController?.navigationController
        let storyBoardInstant = UIStoryboard(name: "Main", bundle: .main)
        let photoViewController = storyBoardInstant.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController
        photoViewController?.attachment = selectedAttachment
        if let vc = photoViewController {
             nav?.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - UIImagePickerDelegate

extension AttachmentCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Selected a photo from the Photo Library
        if let imageURL = info[.imageURL] as? NSURL {
            let stringURL = imageURL.absoluteString
            let imageName = imageURL.lastPathComponent ?? "unknow.jpg"
            
            let attachment = Attachment()
            attachment.name = imageName
            attachment.url = stringURL!
            
            attachmentList?.append(attachment)
        }
        // Captured a photo from camera
        else {
            let originalImage = info[.originalImage] as! UIImage
            // Save the captured image to temporary folder
            let attachment = Attachment()
            attachment.name = attachment.id
            let stringURL = AttachmentController.shared.cache(image: originalImage, name: attachment.name)?.absoluteString
            attachment.url = stringURL!
            
            attachmentList?.append(attachment)
        }
        
        collectionView.reloadData()
        
        topController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDragDelegate

extension AttachmentCollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let attachment = attachmentList?[indexPath.row]
        let dragAttachmentItem = DragAttachmentItem(attachment: attachment!, collectionView: collectionView, indexPath: indexPath)
        dragItem.localObject = dragAttachmentItem
        session.localContext = dragAttachmentItem
        
        return [dragItem]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {

        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .red
        let newX = 25
        let newY = newX
        let bezierPath = UIBezierPath(rect: CGRect(x: newX, y: newY, width: 50, height: 50  ))
        parameters.visiblePath = bezierPath

        return parameters
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        addDeleteZone()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        removeDeleteZone()
    }
    
    private func addDeleteZone() {
        // Get toolbar
        let toolbar = topController?.navigationController?.toolbar
        
        // Setup collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 100)
        let frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        deleteZoneCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        deleteZoneCollectionView?.dragInteractionEnabled = true
        deleteZoneCollectionView?.backgroundColor = .none
        deleteZoneCollectionView?.dropDelegate = self
        //deleteZoneCollectionView?.backgroundColor = .red
        deleteZoneCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        let mainView = topController?.view
        mainView?.addSubview(deleteZoneCollectionView!)
        
        deleteZoneCollectionView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        deleteZoneCollectionView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        deleteZoneCollectionView?.bottomAnchor.constraint(equalTo: toolbar!.topAnchor, constant: -16).isActive = true
        deleteZoneCollectionView?.centerXAnchor.constraint(equalTo: toolbar!.centerXAnchor).isActive = true
        // Add delete image to the collection view
        deleteZoneCollectionView?.backgroundView = imageForDeleteZone(isActive: false)
        
        // Redraw the layout
        topController?.view.layoutIfNeeded()
    }
    
    private func removeDeleteZone() {
        // Hide toolbar
        UIView.animate(withDuration: 1.0) {
            self.topController?.view.layoutIfNeeded()
            self.deleteZoneCollectionView?.removeFromSuperview()
        }
    }
    
    
}

// MARK: - UICollectionDropDelegate

extension AttachmentCollectionViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        for item in coordinator.items {
            if let dragItem = item.dragItem.localObject as? DragAttachmentItem,
                collectionView == deleteZoneCollectionView {
                let sourceCollectionView = dragItem.collectionView
                let indexPath = dragItem.indexPath
                
                attachmentList?.remove(at: indexPath.row)
                sourceCollectionView.deleteItems(at: [indexPath])
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        print("Updating drop section")
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        print("Drop session did end")
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidExit session: UIDropSession) {
        if collectionView == deleteZoneCollectionView {
            deleteZoneCollectionView?.backgroundView = imageForDeleteZone(isActive: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnter session: UIDropSession) {
                
        // Enter the delete zone collection view
        if collectionView == deleteZoneCollectionView {
            deleteZoneCollectionView?.backgroundView = imageForDeleteZone(isActive: true)
            
            // Animations.requireUserAtencion(on: deleteZoneCollectionView!)
            let view = deleteZoneCollectionView?.backgroundView
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
                view?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 10))
                view?.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi + 10))
            }) { (complete) in
            }
        
        }
    }
    
    private func imageForDeleteZone(isActive: Bool) -> UIImageView {
        
        let imageName = isActive ? "ic_delete_active" : "ic_delete"
        let deleteImageView = UIImageView()
        //deleteImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageView.image = UIImage(named: imageName)
        deleteImageView.contentMode = .bottom
        
        return deleteImageView
    }
    
}
