//
//  Issue+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/24/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Issue {
    
    convenience init(summary: String, description: String?, status: Status?,
                     type: IssueType, priority: Priority, createdDate: Date,
                     startDate: Date, endDate: Date, dueDate: Date?) {
        self.init()
        
        self.summary = summary
        self.issueDescription = description ?? ""
        self.status = status
        self.type = type
        self.priority = priority
        
        self.createdDate = createdDate
        self.startDate = startDate
        self.endDate = endDate
        self.dueDate = dueDate
    }
    
}
