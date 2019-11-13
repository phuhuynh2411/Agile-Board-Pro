//
//  RowTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ColumnViewController: UIViewController {
    var columnTableView: ColumnTableView?
        
    
    let dataList1 = [
        Story(summary: "Sed posuere consectetur est at lobortis."),
        Story(summary: "Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."),
        Story(summary: "Aenean lacinia bibendum nulla sed consectetur.")
    ]
    let dataList2 = [
           Story(summary: "Sed posuere consectetur est at lobortis."),
           Story(summary: "Morbi leo risus, porta ac consectetur ac, vestibulum at eros."),
           Story(summary: "Integer posuere erat a ante venenatis dapibus posuere velit aliquet.")
    ]
    let dataList3 = [
           Story(summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
           Story(summary: "Donec ullamcorper nulla non metus auctor fringilla."),
           Story(summary: "Donec sed odio dui.")
    ]
    var list = [Story]()
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        print("Column Table View Controller: View did load")
        
        //print(tableView)
    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        print("Initilize Column Table View Controller")
//        self.loadView()
//    }
    
}
// MARK: - Table View Data Source

extension ColumnViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StoryTableViewCell
    
        return cell
    }
}

// MARK: - Table View Delegate

extension ColumnViewController: UITableViewDelegate {
    
}
