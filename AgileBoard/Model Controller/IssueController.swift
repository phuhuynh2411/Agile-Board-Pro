//
//  IssueController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/14/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class IssueController {
    var realm: Realm?
    
    static var shared = IssueController()
    
    init() {
        do{
            realm = try Realm()
        } catch{
            print(error)
        }
    }
    
    func contain(issue: Issue) -> Bool? {
        return realm?.objects(Issue.self).contains(where: { (issueInRealm) -> Bool in
            issue.id == issueInRealm.id
        })
    }
    
    func add(issue: Issue) {
        do{
            try realm?.write {
                realm?.add(issue)
            }
        } catch{
            print(error)
        }
    }
    
}
