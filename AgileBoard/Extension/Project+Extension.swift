//
//  Project+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/22/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import RealmSwift

extension Project {
    
    func add(_ issue: Issue) throws {
        try realm?.write {
            issue.serial = nextIssueSerial()
            self.issues.append(issue)
        }
    }
    
    func nextIssueSerial()-> Int {
        var max = self.issues.max(ofProperty: "serial") as Int? ?? 0
        max = max == 0 ? 1 : max + 1
        return max
    }
}
