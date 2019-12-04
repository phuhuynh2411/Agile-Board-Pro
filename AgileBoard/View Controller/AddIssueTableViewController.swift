//
//  AddIssueTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class AddIssueTableViewController: UITableViewController {

    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Helper Methods
    
    private func cellAt(indexPath: IndexPath) -> UITableViewCell? {
        var identifer = ""
        
        switch indexPath.row {
        case 0:
            identifer = Identifier.SelectProjectOrTypeCell
            break
        case 1:
            identifer = Identifier.SummaryCell
            break
        case 2:
            identifer = Identifier.DescriptionCell
            break
        default:
            identifer = ""
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer)
        
        return cell
    }
    
    // MARK: - IB Actions
    
    @IBAction func selectProjectPressed(_ sender: Any) {
        print("Select project")
    }
    
    @IBAction func selectTypePressed(_ sender: UITapGestureRecognizer) {
        print("Select type pressed")
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellAt(indexPath: indexPath)!

        return cell
    }
    
}

// MARK: - UI TextView Delegate

extension AddIssueTableViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
       
        
        // Dismiss the keyboard when pressing on the return key
        // Only apply for the summary field
        if text == "\n", textView.tag == 1{
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.frame.size =  CGSize(width: cell!.frame.size.width, height: newSize.height + CGFloat(12) )
            // tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.rowHeight = newSize.height + CGFloat(12)
        }
        
    }
    
}
