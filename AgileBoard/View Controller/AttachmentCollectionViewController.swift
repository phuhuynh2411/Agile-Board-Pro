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

    // MARK: Init Methods
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
            
        attachmentList = List<Attachment>()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: IB Actions
    
    @objc func addAttachment(sender: UIButton) {
        print("Add attachment pressed")
        
        let alert = UIAlertController(title: "", message: "Select the following options to add the attachments.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel pressed")
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            print("Camera pressed")
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
        
        // Veriry the photo library
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("The Photo Library is not available")
            return
        }
       topController?.present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentList?.count ?? 0
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
    
}

// MARK: - UIImagePickerDelegate

extension AttachmentCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[.imageURL] as! NSURL
        let stringURL = imageURL.absoluteString
        let imageName = imageURL.lastPathComponent ?? "unknow.jpg"
        
        let attachment = Attachment()
        attachment.name = imageName
        attachment.url = stringURL!
        
        attachmentList?.append(attachment)
        collectionView.reloadData()
        
        topController?.dismiss(animated: true, completion: nil)
    }
    
//    print("Did select photo")
//    let originalImage = info[.originalImage] as! UIImage
//    // let editedImage = info[.editedImage] as! UIImage
//    let imageURL = info[.imageURL] as! NSURL
//    print(imageURL.absoluteString)
//
//    let attachment = Attachment()
//    attachment.name = imageURL.lastPathComponent ?? "unknow.jpg"
//
//    AttachmentController.shared.add(attachment: attachment, image: originalImage)
}

