//
//  ColumnTableView.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ColumnTableView: UITableView {
    
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//
//        print("Table view load")
//    }
//
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Make the table view rounded.
        self.layer.cornerRadius = 5.0
        
    }
}
