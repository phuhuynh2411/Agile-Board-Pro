//
//  AttachmentController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/5/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class AttachmentController {
    
    var documentFolerPath: URL {
        return FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    var attachmentFolderPath: URL {
        return documentFolerPath.appendingPathComponent("attachments", isDirectory: true)
    }
    
    var realm: Realm?
    
    init() {
        do{
            self.realm  = try Realm()
        }catch let error as NSError {
            print(error)
        }
    }
    
    static var shared = AttachmentController()
    
    func add(attachment: Attachment, image: UIImage) {
        
        let folderURL = attachmentFolderPath.appendingPathComponent(attachment.id, isDirectory: true)
        
        let fileManager = FileManager()
        
        // Create the folder if it does not exist
        if !fileManager.fileExists(atPath: folderURL.absoluteString) {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                print("Folder was created.")
            } catch {
                print("Folder was not created with error: \(error)")
            }
        }
        
        let fileURL = folderURL.appendingPathComponent(attachment.name)
        let jpegData = image.jpegData(compressionQuality: 1.0)
        
        // Write the image to the fileURL
        do{
            try jpegData?.write(to: fileURL)
            print("The image was saved at path \(fileURL.absoluteString)")
        }catch {
            print("Image was not saved with error \(error)")
        }
    
    }
    
}
