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
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)
        //let headerView = UIView(frame: frame)
        
        //headerView.translatesAutoresizingMaskIntoConstraints = false
        //let textView = UITextView()
        //textView.backgroundColor = .red
        //textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.delegate = self
        //headerView.addSubview(textView)
        //headerView.backgroundColor = .blue
        
        //textView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 100).isActive = true
       // textView.isScrollEnabled = false

        
        //tableView.tableHeaderView = headerView
        //heightConstraint = headerView.heightAnchor.constraint(equalToConstant: 300)
        //heightConstraint?.isActive = true
        
        //headerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        // tableView.sectionHeaderHeight = 200
        
        let nib = UINib(nibName: "AddIssueHeaderView", bundle: .main)
        let headerView = nib.instantiate(withOwner: self, options: nil).first as! AddIssueHeaderView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
       //headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0.0).isActive = true
//        headerView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0.0).isActive = false
        
        //headerView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
       
        let label = UILabel()
        label.text = "testing..."
        label.backgroundColor = .red
        label.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        
        headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 300 )
        
//        let anotherView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
//        anotherView.backgroundColor = .red
//        anotherView.addSubview(headerView)
//        headerView.trailingAnchor.constraint(equalTo: anotherView.trailingAnchor).isActive = true
//        headerView.leadingAnchor.constraint(equalTo: anotherView.leadingAnchor).isActive = true
        

        tableView.tableHeaderView = headerView
        
        
       // self.view.layoutIfNeeded()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "Testing..."

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
        
        heightConstraint?.constant = newSize.height
        tableView.reloadData()
        //self.view.layoutIfNeeded()
        // tableView.sizeToFit()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.frame.size =  CGSize(width: cell!.frame.size.width, height: newSize.height + CGFloat(12) )
            // tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.rowHeight = newSize.height + CGFloat(12)
        }
        
        print("Text view did change")
        
    }
    
}
