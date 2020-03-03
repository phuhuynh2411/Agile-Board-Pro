//
//  ListExension.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/30/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

extension List where List.Element == Board {
    
    func remove() throws {
        for element in self.elements {
            let board = element as Board
            try board.remove()
        }
    }
}

extension List where List.Element == Issue {
    
    func remove() throws {
        for element in self.elements {
            let issue = element as Issue
            try issue.remove()
        }
    }
}

extension List where List.Element == Attachment {
    
    func remove() throws {
        for element in self.elements {
            let attachment = element as Attachment
            try attachment.remove()
        }
    }
}
