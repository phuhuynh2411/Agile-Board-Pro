//
//  Status+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Status {
    
    static var todo: Status {
        return status(name: "TO DO", color: .todo)
    }
    
    static var inprogress: Status {
        return status(name: "IN PROGRESS", color: .inprogress)
    }
    
    static var done: Status {
        let s = status(name: "DONE", color: .done)
        s.markedAsDone = true
        return s
    }
    
    static func todo(of project: Project) -> Status? {
        let status = project.statuses.filter { (status) -> Bool in
            status.name == todo.name
        }.first
        return status
    }
    
    static func inprogress(of project: Project) -> Status? {
        let status = project.statuses.filter { (status) -> Bool in
            status.name == inprogress.name
        }.first
        return status
    }
    
    static func done(of project: Project) -> Status? {
        let status = project.statuses.filter { (status) -> Bool in
            status.name == done.name
        }.first
        return status
    }
    
    static func status(name: String, color: Color) -> Status {
        let status = Status()
        status.name = name
        status.color = color
        return status
    }
}
