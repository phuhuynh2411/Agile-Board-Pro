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
    
    var tempFolderPath: URL {
        return NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).filePathURL!
    }
    
    var realm = AppDataController.shared.realm

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
    
    func cache(image: UIImage, name: String) -> URL? {
    
        let fileURL = tempFolderPath.appendingPathComponent(name).appendingPathExtension("jpeg")
        let jpegData = image.jpegData(compressionQuality: 1.0)
        
        // Write the image to the fileURL
        do{
            try jpegData?.write(to: fileURL)
            print("The image was saved at path \(fileURL.absoluteString)")
        }catch {
            print("Image was not saved with error \(error)")
            return nil
        }
        return fileURL
    }
    
    func save(image: UIImage) throws -> String {
        
        let fileManager = FileManager()
        
        // Create the folder if it does not exist
        if !fileManager.fileExists(atPath: attachmentFolderPath.path) {
            try fileManager.createDirectory(at: attachmentFolderPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let name = UUID().uuidString
        let fileURL = attachmentFolderPath.appendingPathComponent(name).appendingPathExtension("jpeg")
        let jpegData = image.jpegData(compressionQuality: 1.0)
        
        
        // Write the image to the fileURL
        try jpegData?.write(to: fileURL)
        
        return fileURL.lastPathComponent
    }
    
    func delete(_ fileName: String) throws {
        let fileURL = attachmentFolderPath.appendingPathComponent(fileName)
        try FileManager().removeItem(at: fileURL)
    }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = attachmentFolderPath.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }

}
