//
//  IssueFilter.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/13/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

protocol IssueFilterDelegate {
    func sectionFor(_ issue: Issue)->String
}

typealias IssueFilter = BaseIssueFilter & IssueFilterDelegate

class BaseIssueFilter {
    var name: String
    var imageName: String
    
    var issues: Results<Issue>? {
        return nil
    }
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
