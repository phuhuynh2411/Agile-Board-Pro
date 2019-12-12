//
//  AddIssueTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

enum AvailableTableCell {
    case priority
    case attachment
    case collection
    case dueDate
}

class AddIssueTableViewController: UITableViewController {

    // MARK: Properites
    
    var headerView: AddIssueHeaderView?
    
    /// current project
    var project: Project?
    
    /// Selected Issue Type
    var selectedIssueType: IssueType?
    
    var delegate: AddIssueDelegate?
        
    var selectedPriority: Priority?
    
    var cellList: [AvailableTableCell]?
    var selectedCellList: [AvailableTableCell]?
    
    /// A UILable of number of attachments
    var numberOfAttachments: UILabel?
    
    var attachmentList: List<Attachment>?
        
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        setUpHeader()
        projectData()
        issueTypeData()
        setUpCell()
        
        // Create a medium priority as the default one
        selectedPriority = PriorityController.shared.getDefault()
        
        attachmentList = List<Attachment>()
        
    }
    
    private func updateView() {
        projectData()
        issueTypeData()
        
        tableView.reloadData()
    }
    
    private func projectData() {
        // Update project name
        let projectButton = headerView?.projectButton
        if let projectName = project?.name {
            projectButton?.isSelected = true
            projectButton?.setTitle(projectName, for: .selected)
        }
    }
    
    private func issueTypeData() {
        // Update issue type
        let typeButton = headerView?.typeButton
        if let issueType = selectedIssueType?.name {
            typeButton?.isSelected = true
            typeButton?.setTitle(issueType, for: .selected)
        }
        
        if let issueImageName = selectedIssueType?.imageName {
            headerView?.typeImageView.image = UIImage(named: issueImageName)
            headerView?.showTypeIcon = true
        }
        else {
            headerView?.showTypeIcon = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        //headerFitTextView()
    }
    
    // MARK: - Set Up table view header view
    
    private func setUpHeader() {
        
        let nib = UINib(nibName: "AddIssueHeaderView", bundle: .main)
        headerView = nib.instantiate(withOwner: self, options: nil).first as? AddIssueHeaderView
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        headerView?.summaryTextView.delegate = self
        headerView?.descriptionTextView.delegate = self
        
        let parentView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: headerView!.frame.height))
        parentView.addSubview(headerView!)
        headerView?.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        headerView?.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        headerView?.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        headerView?.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
  
        tableView.tableHeaderView = parentView
        
        // Set up actions
        headerView?.projectButton.addTarget(self, action: #selector(selectProjectPressed(sender:)), for: .touchUpInside)
        headerView?.typeButton.addTarget(self, action: #selector(selectTypePressed(sender:)), for: .touchUpInside)
        headerView?.showMoreButton.addTarget(self, action: #selector(showMoreButtonPress(sender:)), for: .touchUpInside)
    }
    
    // MARK: - Setup table view cell
    
    private func setUpCell() {
        selectedCellList = [AvailableTableCell]()
        selectedCellList?.append(.priority)
        selectedCellList?.append(.attachment)
        selectedCellList?.append(.dueDate)
        //selectedCellList?.append(.collection)
    }
    
    // MARK: - Helper Methods
    
    private func cellAt(indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell?
        
        switch cellList?[indexPath.row] {
        case .priority:
            cell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell")
            break
        case .attachment:
            cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentCell")
            break
        case .collection:
            cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell")
            break
        case .dueDate:
            cell = tableView.dequeueReusableCell(withIdentifier: "DueDateCell")
            break
        default: break
        }
        
        // Add data to priority cell
        if let priorityCell = cell as? IssuePriorityTableViewCell {
            priorityCell.priorityNameLabel?.text = selectedPriority?.name
            if let imageName = selectedPriority?.imageName {
                priorityCell.priorityImageView.image = UIImage(named: imageName)
            }
        }
        
        // Attachment Cell
        if let attachmentCell = cell as? AttachmentTableViewCell {
            attachmentCell.numberLabel.text = "\(attachmentList?.count ?? 0)"
            numberOfAttachments = attachmentCell.numberLabel
        }
        
        // Collection cell
        if let collectionCell = cell as? AddIssueCollectionTableViewCell {
            let controller = collectionCell.collectionView.controller
            controller?.attachmentList = attachmentList
            controller?.numberLabel = numberOfAttachments
        }
        
        // Due date cell
        if let dueDateCell = cell as? DueDateTableViewCell {
            // Do something here
        }
        
        return cell
    }
    
    /**
     A best fitting size for text view
     */
    private func fitTextViewSize(textView: UITextView){
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        textView.frame.size =  CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    /**
     Adjusts the table view header to fit the text view height
     */
    private func headerFitTextView() {
        let size = tableView.frame.size
        tableView.tableHeaderView?.frame.size = CGSize(width: size.width, height: headerView!.viewHeight())
        tableView.reloadData()
    }
    
    // MARK: - IB Actions
    
    @objc func selectProjectPressed(sender: UIButton) {
        performSegue(withIdentifier: Identifier.SearchProjectSegue, sender: self)
    }
    
    @objc func selectTypePressed(sender: UIButton) {
        performSegue(withIdentifier: Identifier.SelectIssueTypeSegue, sender: self)
    }
    
    @objc func showMoreButtonPress(sender: UIButton) {
        // Remove all cell from the table view
        if headerView!.showMoreField {
            let indexPaths = cellList?.enumerated().compactMap{ IndexPath(row: $0.offset, section: 0)}
            cellList = nil
            tableView.deleteRows(at: indexPaths!, with: .none)
        }
        // Add selected cells to the table view
        else {
            let indexPaths = selectedCellList?.enumerated().compactMap{ IndexPath(row: $0.offset, section: 0)}
            cellList = selectedCellList
            tableView.insertRows(at: indexPaths!, with: .automatic)
        }
        tableView.reloadData()
    }

    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList?.count ?? 0
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
        if text == "\n", textView == headerView?.summaryTextView {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        fitTextViewSize(textView: textView)
        headerFitTextView()
    }
    
}

// MARK: - SelectProjectProtocol

extension AddIssueTableViewController: SelectProjectDelegate {
    
    func didSelectdProject(project: Project?) {
        self.project = project
        
        // Reload the UI
        updateView()
    }
    
}

// MARK: - Navigation

extension AddIssueTableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the selected project to the Serach Project View Controller
        if segue.identifier == Identifier.SearchProjectSegue {
            let navigationController = segue.destination as! UINavigationController
            let searchProjectViewController = navigationController.topViewController as! SearchProjectViewController
            searchProjectViewController.selectedProject = project
            searchProjectViewController.delegate = self
        }
        
        if segue.identifier == Identifier.SelectIssueTypeSegue {
            let navigationController = segue.destination as! UINavigationController
            let selectIssueTypeTableViewController = navigationController.topViewController as! SelectIssueTypeTableViewController
            
            selectIssueTypeTableViewController.selectedIssueType = selectedIssueType
            selectIssueTypeTableViewController.delegate = self
        }
        
        if segue.identifier == Identifier.SelectPrioritySegue {
            let priorityTableController = segue.destination as! PriorityTableViewController
            priorityTableController.selectedPriority = selectedPriority
            priorityTableController.delegate = self
        }
        
        if segue.identifier == Identifier.DueDateSegue {
            segue.destination.transitioningDelegate  = self
            segue.destination.modalPresentationStyle = .custom
        }
        
    }
}

// MARK: - SelectIssueType Delegate

extension AddIssueTableViewController: SelectIssueTypeDelegate {
    
    func didSelectIssueType(issueType: IssueType?) {
        self.selectedIssueType = issueType
                
        updateView()
    }
}

// MARK: - UI Table View Delegate

extension AddIssueTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Priority cell
        if cellList?[indexPath.row] == .priority {
            performSegue(withIdentifier: Identifier.SelectPrioritySegue, sender: self)
        }
        // Tap on the attachment cell
        else if cellList?[indexPath.row] == .attachment {
            
            // Add or remove collection cell
            let cell = tableView.cellForRow(at: indexPath) as! AttachmentTableViewCell
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if cellList!.contains(.collection) {
                cellList?.removeAll(where: { (cell) -> Bool in
                    cell == .collection
                })
                cell.isTransform = false
                let nextCell = tableView.cellForRow(at: nextIndexPath)
                // Hide the cell before removing from the table view
                nextCell?.isHidden = true
                tableView.deleteRows(at: [nextIndexPath], with: .automatic)
            } else {
                cellList?.insert(.collection, at: nextIndexPath.row)
                cell.isTransform = true
                tableView.insertRows(at: [nextIndexPath], with: .automatic)
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
           // tableView.reloadData()
        }
        else if cellList?[indexPath.row] == .dueDate {
            performSegue(withIdentifier: Identifier.DueDateSegue, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cellList?[indexPath.row] {
        case .priority:
            return 70
        case .attachment:
            return 44
        case .collection:
            return 116
        case .dueDate:
            return 70
        default:
            return 44
        }
        
    }
    
}

// MARK: - Select Priority Delegate

extension AddIssueTableViewController: SelectPriorityDelegate {
    
    func didSelectPriority(priority: Priority) {
        selectedPriority = priority
        updateView()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AddIssueTableViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
