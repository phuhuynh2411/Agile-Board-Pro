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
    
    func update(_ status: Status, to issue: Issue) {
        do{
            try realm?.write {
                issue.status = status
            }
        }catch{
            print(error)
        }
    }
    
    func update(_ priority: Priority, to issue: Issue) {
        do{
            try realm?.write {
                issue.priority = priority
            }
        }catch{
            print(error)
        }
    }
    
    func update(dueDate: Date, to issue: Issue) {
        do{
            try realm?.write {
                issue.dueDate = dueDate
            }
        }catch{
            print(error)
        }
    }
    
    func update(startDate: Date, to issue: Issue) {
        do{
            try realm?.write {
                issue.startDate = startDate
            }
        }catch{
            print(error)
        }
    }
    
    func update(endDate: Date, to issue: Issue) {
        do{
            try realm?.write {
                issue.endDate = endDate
            }
        }catch{
            print(error)
        }
    }
    
    func add(_ attachment: Attachment, to issue: Issue) {
        do{
            try realm?.write {
                issue.attachments.append(attachment)
            }
        }catch{
            print(error)
        }
    }
    
    func delete(_ attachment: Attachment) {
        do{
            try realm?.write {
                realm?.delete(attachment)
            }
        }catch{
            print(error)
        }
    }
    
    func update(summary: String, description: String, to issue: Issue) {
        do{
            try realm?.write {
                issue.summary = summary
                issue.issueDescription = description
            }
        }catch{
            print(error)
        }
    }
    
}
