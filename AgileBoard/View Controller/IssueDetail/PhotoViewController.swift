//
//  PhotoViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/6/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: Properties
    
    var attachment: Attachment?

    // MARK: View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        guard let attachment = self.attachment else  { return }
        
        let ac = AttachmentController()
        if let image = ac.load(fileName: attachment.name) {
            photoImageView.image = image
        }
    }
    
}

extension PhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }

}
