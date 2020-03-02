//
//  Attachment+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 3/2/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

extension Attachment {
    
    override func remove() throws {
        try AttachmentController().delete(self.name)
        try super.remove()
    }
}
