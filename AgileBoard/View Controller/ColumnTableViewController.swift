//
//  RowTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ColumnTableViewController: UITableViewController {
    
    var columnIndexPath: IndexPath?
        
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
    var list = [[Story]]()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        print("\(ColumnTableViewController.self):  View did load")
        list.append(dataList1)
        list.append(dataList2)
        list.append(dataList3)
    }
    
    func tableView(reloadAt indexPath: IndexPath) {
        print("Column Table View Controller: Reload at index path \(indexPath)")
        columnIndexPath = indexPath
        
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[columnIndexPath?.row ?? 0].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StoryTableViewCell
        if let column = columnIndexPath {
            let data = list[column.row]
            cell.summaryLabel.text = data[indexPath.row].summary
        }
        
        return cell
    }
    
}
