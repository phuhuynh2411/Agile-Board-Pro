//
//  SettingTableViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    let appDataController   = AppDataController.shared
    let numberOfProjects    = 5

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Tap on the row of creatinng 5 sample projects
        if (indexPath.row, indexPath.section) == (1, 1) {
            self.createSampleProjects()
        }
    }
    
    private func createSampleProjects() {
        
        let alertController = UIAlertController(title: "", message: "Create five sample projects to the app. They are used for testing only. You could use them to play with the app.", preferredStyle: .actionSheet)
        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            self.appDataController.add(sampleProjects: self.numberOfProjects)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_ ) in }
            
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
