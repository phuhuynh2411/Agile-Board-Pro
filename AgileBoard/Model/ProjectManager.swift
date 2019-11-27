//
//  ProjectManager.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/22/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import Foundation

class ProjectManager {
    
    ///
    /// Load sample data for the project
    ///
    static func loadProjectSampleData() -> Project {
        
        // 1. Create a new project
        let project = Project()
        project.name = "New Project"
        
        // 2. Create statuses
        let todo = Status()
        todo.name = "To Do"
        let inprogress = Status()
        inprogress.name = "In Progress"
        let done = Status()
        done.name = "Done"
        
        let completed = Status()
        done.name = "Completed"
        
        // 3. Create issues
        let issue1 = Issue()
        issue1.summary = "Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum."
        issue1.status = todo
        issue1.orderNumber = 0
        
        let issue2 = Issue()
        issue2.summary = "Fringilla Fusce"
        issue2.status = todo
        issue2.orderNumber = 1
        
        let issue3 = Issue()
        issue3.summary = "Donec sed odio dui."
        issue3.status = todo
        issue3.orderNumber = 2
        
        let issue4 = Issue()
        issue4.summary = "Curabitur blandit tempus porttitor."
        issue4.status = inprogress
        issue4.orderNumber = 3
        
        let issue5 = Issue()
        issue5.summary = "Nulla vitae elit libero, a pharetra augue."
        issue5.status = inprogress
        issue5.orderNumber = 4
        
        let issue6 = Issue()
        issue6.summary = "Sed posuere consectetur est at lobortis."
        issue6.status = done
        issue6.orderNumber = 5
        
        let issue7 = Issue()
        issue7.summary = "Cras mattis consectetur purus sit amet fermentum."
        issue7.status = completed
        issue7.orderNumber = 6
        
        let issue8 = Issue()
        issue8.summary = "Vestibulum id ligula porta felis euismod semper."
        issue8.status = completed
        issue8.orderNumber = 7
        
        // 4. Add issues to the project
        project.issues.append(issue1)
        project.issues.append(issue2)
        project.issues.append(issue3)
        project.issues.append(issue4)
        project.issues.append(issue5)
        project.issues.append(issue6)
        project.issues.append(issue7)
        project.issues.append(issue8)
        
        // 5. Create columns
        let column1 = Column()
        column1.name = "TO DO"
        column1.status = todo
        
        let column2 = Column()
        column2.name = "IN PROGRESS"
        column2.status = inprogress
        
        let column3 = Column()
        column3.name = "DONE"
        column3.status = done
        
        let column4 = Column()
        column4.name = "COMPLETED"
        column4.status = completed
        
        // 6. Create board
        let board = Board()
        board.name = "Default Board"
        board.columns.append(column1)
        board.columns.append(column2)
        board.columns.append(column3)
        board.columns.append(column4)
        
        // 7. Add board to the project
        project.boards.append(board)
        
        return project
        
    }
    
}

