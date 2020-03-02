//
//  SettingTableViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/28/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import MessageUI

class SettingTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sendFeedbackCell: UITableViewCell!
    @IBOutlet weak var aboutCell: UITableViewCell!
    @IBOutlet weak var createSampleProjectCell: UITableViewCell!
    @IBOutlet weak var verionLabel: UILabel!
    
    let appDataController   = AppDataController.shared
    let numberOfProjects    = 5

    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        verionLabel.text = appDataController.version ?? ""
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell == aboutCell {
            self.performSegue(withIdentifier: "AboutSegue", sender: self)
        } else if cell == sendFeedbackCell {
            self.sendFeeback()
        } else if cell == createSampleProjectCell {
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
    
    private func sendFeeback() {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
         
        // Configure the fields of the interface.
        composeVC.setToRecipients(["support@filesoft.co"])
        composeVC.setSubject("Agile Board feedback")
        
        let device = UIDevice.current
        let body = """
        \n\n
        ----------
        \(device.name)
        \(device.systemName) \(device.systemVersion)
        App version: \(appDataController.version ?? "")
        """
        composeVC.setMessageBody(body, isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
}

extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
