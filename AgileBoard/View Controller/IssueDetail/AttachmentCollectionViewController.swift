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

protocol AttachmentCollectionViewDelegate {
    func didAdd(_ attachment: Attachment)
}

class AttachmentCollectionViewController: UICollectionViewController {
    
    // MARK: Properities
    
    private var attachments: List<Attachment>?
    
    private var topController = UIApplication.getTopViewController()
    
    private var selectedAttachment: Attachment?
        
    /// Attachment delegate
    var delegate: AttachmentCollectionViewDelegate?
    
    private var deleteZoneCollectionView: UICollectionView?
    
    private var isStartDragging = false

    // MARK: Init Methods
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Initilize the view with or without attachments. If the attachments array is nil, it will create a new empty array; otherwise the attachments array is set to the attachments arrary parameter.
     - Parameters:
        - attachments: A attachments array
        - delegate: Callback functions called after adding a new attachment.
     */
    func initView(attachments: List<Attachment>, delegate: AttachmentCollectionViewDelegate? = nil) {
        self.attachments = attachments
        self.delegate = delegate
    }
    
    // MARK: IB Actions
    
    @objc func addAttachment(sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Select the following options to add the attachments. Press OK if there is any message prompts out.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_ ) in }
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

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = attachments?.count ?? 0
        
        // If there is no attachment,
        // add Inset right with 10 pt for the footer (the add button)
        if count > 0 {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AttachmentCollectionViewCell
        
        let attachment = attachments?[indexPath.row]
        let ac = AttachmentController()
        if let name = attachment?.name, let image = ac.load(fileName: name) {
            cell.attachmentImageView.image = image
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
        
        selectedAttachment = attachments?[indexPath.row]
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
        
        guard let originalImage = info[.originalImage] as? UIImage else { return }
        
        let attachment = Attachment()
        let ac = AttachmentController()
        do{
            attachment.name = try ac.save(image: originalImage)
        }catch { print(error); return }
        
        delegate?.didAdd(attachment)
        
        collectionView.reloadData()
        
        topController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDragDelegate

extension AttachmentCollectionViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let attachment = attachments?[indexPath.row]
        let dragAttachmentItem = DragAttachmentItem(attachment: attachment!, collectionView: collectionView, indexPath: indexPath)
        dragItem.localObject = dragAttachmentItem
        session.localContext = dragAttachmentItem
        
        // Add delete zone
        if deleteZoneCollectionView == nil {
            deleteZoneCollectionView = DeleteZoneCollectionView()
            // If user is not dragging the item after 3 second. Auto removes the delete zone.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if !self.isStartDragging { self.removeDeleteZone() }
            }
        }
        
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
        // User starts dragging the item
        self.isStartDragging = true
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        removeDeleteZone()
        self.isStartDragging = false
    }
    
    private func removeDeleteZone() {
        guard deleteZoneCollectionView != nil else { return }
        
        self.deleteZoneCollectionView?.removeFromSuperview()
        self.deleteZoneCollectionView = nil
    }
}
