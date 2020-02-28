//
//  Project+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/22/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import RealmSwift

extension Project {
    
    convenience init(name: String, description: String?, key: String, icon: ProjectIcon? = nil) {
        self.init()
        
        self.name                   = name
        self.projectDescription     = description ?? ""
        self.key                    = key
        self.icon                   = icon
        
        statuses.append(objectsIn: [.todo, .inprogress, .done])
        let board = Board.main(of: self)
        boards.append(board)
        selectedBoard = board
    
    }
    
    func add(_ issue: Issue) throws {
        if self.realm != nil {
            try self.write { self._add(issue) }
        } else {
            self._add(issue)
        }
    }
    
    private func _add(_ issue: Issue) {
        issue.serial = nextIssueSerial()
        self.issues.append(issue)
    }
    
    private func nextIssueSerial()-> Int {
        var max = self.issues.max(ofProperty: "serial") as Int? ?? 0
        max = max == 0 ? 1 : max + 1
        return max
    }
    
    func add(testIssue: TestIssue) {
        for issue in testIssue.issues {
            try! self.add(issue)
        }
    }
}
