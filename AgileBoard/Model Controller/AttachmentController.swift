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
    
    func saveToDocumentFolder(image: UIImage, name: String) -> URL? {
    
        let fileURL = attachmentFolderPath.appendingPathComponent(name).appendingPathExtension("jpeg")
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
    
    /**
     Move the attachment from a temporary folder into the document folder
     */
    func document(attachment: Attachment, completion: (_ error: Error?)->Void) {
        
        let fileManager = FileManager()
        
        // Create the folder if it does not exist
        if !fileManager.fileExists(atPath: attachmentFolderPath.absoluteString) {
            do {
                try fileManager.createDirectory(at: attachmentFolderPath, withIntermediateDirectories: true, attributes: nil)
                print("attachments folder was created.")
            } catch {
                print("attachment folder was not created with error: \(error)")
            }
        }
        
        let fileURL = attachmentFolderPath.appendingPathComponent(attachment.id).appendingPathExtension("jpeg")
        let newFile = fileURL.path
        let oldFile = tempFolderPath.appendingPathComponent(attachment.id).appendingPathExtension("jpeg").path
                
        do{
            try fileManager.moveItem(atPath: oldFile, toPath: newFile)
            try realm?.write {
                attachment.url = fileURL.absoluteString
            }
            completion(nil)
        }catch{
            print(error)
            completion(error)
        }
    }
    
}
