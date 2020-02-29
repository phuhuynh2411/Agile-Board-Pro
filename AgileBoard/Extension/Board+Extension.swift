//
//  Board+Extension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/26/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Board {
    
    static func main(of project: Project) -> Board {
        let board = Board(name: "Main Board")
                
        board.columns.append(objectsIn: [
            .todo(status: .todo(of: project)),
            .inprogress(status: .inprogress(of: project)),
            .done(status: .done(of: project))
        ])
        
        return board
    }
    
    convenience init(name: String) {
        self.init()
        
        self.name = name
    }
    
    override func remove() throws {
        do{
            try realm?.write{
                realm?.delete(self.columns)
            }
        }catch { print(error) }
        
        try super.remove()
    }
}
