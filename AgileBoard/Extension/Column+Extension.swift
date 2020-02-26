//
//  Column+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Column {
    
    static var todo: Column {
        return self.column(name: "TO DO")
    }
    
    static var inprogress: Column {
        return self.column(name: "IN PROGRESS")
    }
    
    static var done: Column {
        return self.column(name: "DONE")
    }
    
    static func todo(status: Status?) -> Column {
        return column(.todo, status: status)
    }
    
    static func inprogress(status: Status?) -> Column {
           return column(.inprogress, status: status)
    }
    
    static func done(status: Status?) -> Column {
           return column(.done, status: status)
    }
    
    static func column(name: String) -> Column {
        let column = Column()
        column.name = name
        return column
    }
    
    static func column(_ column: Column, status: Status?) -> Column {
        column.status = status
        return column
    }
}
