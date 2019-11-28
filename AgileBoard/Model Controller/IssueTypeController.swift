//
//  IssueTypeController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/28/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation
import RealmSwift

class IssueTypeController {
    
    lazy var realm = try! Realm()

    func createSampleIssueTypes() {
        
        let issueType1 = IssueType()
        issueType1.name = "Story"
        issueType1.imageName = "issue_story"
        issueType1.typeDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna."
        
        let issueType2 = IssueType()
        issueType2.name = "Epic"
        issueType2.imageName = "issue_epic"
        issueType2.typeDescription = "Etiam porta sem malesuada magna mollis euismod. Maecenas sed diam eget risus varius blandit sit amet non magna."
        
        let issueType3 = IssueType()
        issueType3.name = "Task"
        issueType3.imageName = "issue_task"
        issueType3.typeDescription = "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Nullam id dolor id nibh ultricies vehicula ut id elit."
        
        let issueType4 = IssueType()
        issueType4.name = "Bug"
        issueType4.imageName = "issue_bug"
        issueType4.typeDescription = "Donec ullamcorper nulla non metus auctor fringilla."
        
        do {
            try realm.write {
                realm.add(issueType1)
                realm.add(issueType2)
                realm.add(issueType3)
                realm.add(issueType4)
            }
        }
        catch let error as NSError {
            print(error.description)
        }
        
    }
    
    func all()-> Results<IssueType> {
        return realm.objects(IssueType.self)
    }
}
