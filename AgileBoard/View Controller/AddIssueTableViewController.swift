//
//  AddIssueTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class AddIssueTableViewController: UITableViewController {
    
    // MARK: Properites
    
    var headerView: AddIssueHeaderView?
    
    /// current project
    var project: Project?
    
    /// Selected Issue Type
    var selectedIssueType: IssueType?
    
    var delegate: AddIssueDelegate?
        
    var selectedPriority: Priority?
    
    private var Cells: [CellType]?
    
    /// A UILable of number of attachments
    var numberOfAttachments: UILabel?
    
    var attachments: [Attachment]?
        
    /// Due date
    var dueDate: Date?
    
    /// Start Date
    var startDate: Date?
    
    /// End Date
    var endDate: Date?
    
    /**
     Determines whether users modifed any data in the form.
     `isModifed` is equal `true` if the data was modified; otherwise `false`
    */
    var isModifed: Bool = false
    
    var issue: Issue? { didSet { issueDidChange() }}
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        
        setUpHeader()
        projectData()
        issueTypeData()
        
        // Create a medium priority as the default one
        selectedPriority = PriorityController.shared.getDefault()
        
        attachments = []
    
        // Dismiss the keyboard when dragging on the table view
        tableView.keyboardDismissMode = .onDrag
        
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
    
    // MARK: - Helper Methods
    
    private func cellAt(indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell?
        
        switch Cells?[indexPath.row] {
        case .priority:
            cell = tableView.dequeueReusableCell(withIdentifier: C.prioriy)
            break
        case .attachment:
            cell = tableView.dequeueReusableCell(withIdentifier: C.attachment)
            break
        case .collection:
            cell = tableView.dequeueReusableCell(withIdentifier: C.collecion)
            break
        case .dueDate:
            cell = tableView.dequeueReusableCell(withIdentifier: C.dueDate)
            break
        case .startDate:
            cell = tableView.dequeueReusableCell(withIdentifier: C.startDate)
            break
        case .endDate:
            cell = tableView.dequeueReusableCell(withIdentifier: C.endDate)
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
            attachmentCell.numberLabel.text = "\(attachments?.count ?? 0)"
            numberOfAttachments = attachmentCell.numberLabel
        }
        
        // Collection cell
        if let collectionCell = cell as? AddIssueCollectionTableViewCell {
            let controller = collectionCell.collectionView.controller
            // MARK: TODO: -  Need to update here
            //controller?.attachmentList = attachmentList
            controller?.numberLabel = numberOfAttachments
        }
        
        // Due date cell
        if let dueDateCell = cell as? DueDateTableViewCell {
            if let date = dueDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dueDateCell.dueDateLabel.text = dateFormatter.string(from: date)
            }
            else {
                dueDateCell.dueDateLabel.text = ""
            }
            dueDateCell.updateCell()
        }
        
        // Start date cell
        if let startDateCell = cell as? StartDateTableViewCell {
            if let date = startDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                startDateCell.startDateLabel.text = dateFormatter.string(from: date)
            }
            else {
                startDateCell.startDateLabel.text = ""
            }
            startDateCell.updateCell()
        }
        
        // End date cell
        if let endDateCell = cell as? EndDateTableViewCell {
            if let date = endDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                endDateCell.endDateLabel.text = dateFormatter.string(from: date)
            }
            else {
                endDateCell.endDateLabel.text = ""
            }
            endDateCell.updateCell()
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
    
    private func prepareForDateCell(segue: UIStoryboardSegue, date: Date?, dateType: DateType) {
        // Get the selecte date view controller
        let navigationController = segue.destination as! UINavigationController
        let selectDateViewController = navigationController.topViewController as! SelectDateViewController
        // Set SelectDateDelegate
        selectDateViewController.delegate = DateController(callback: { (selectedDate) in
            switch dateType{
            case .dueDate:
                self.dueDate = selectedDate
                break
            case .startDate:
                self.startDate = selectedDate
                break
            case .endDate:
                self.endDate = selectedDate
                break
            }
            self.tableView.reloadData()
            self.isModifed = true
        })
        // Displays the previous selected date
        selectDateViewController.selectedDate = date
        
        // Set segue transitioning
        segue.destination.transitioningDelegate  = self
        segue.destination.modalPresentationStyle = .custom
        
    }
    
    /**
     Determines whether the user are modifying an exising issue or adding a new one.
     - Returns: `true` if the use are adding a new issue; otherwise `false`
     */
    func isNew() -> Bool{
        // If realm database does not contain the issue,
        // it is the new one; otherwise, it is an exsiting issue.
        if let issue = issue {
            guard let isExisting = IssueController.shared.contain(issue: issue) else { return true }
            return !isExisting
        }else{
            return true
        }
    }
    
    func issueDidChange() {
        print("Issue has been changed.")
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
            let indexPaths = Cells?.enumerated().compactMap{ IndexPath(row: $0.offset, section: 0)}
            Cells = nil
            tableView.deleteRows(at: indexPaths!, with: .none)
        }
        // Add selected cells to the table view
        else {
            Cells = [CellType]()
            Cells?.append(.priority)
            Cells?.append(.attachment)
            Cells?.append(.dueDate)
            Cells?.append(.startDate)
            Cells?.append(.endDate)
            
            tableView.reloadData()
        }
    }

    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        // Prevents user lose entered data
        // Shows a popup to ask user whether they really want to discard the changes
        if isModifed {
            let alertController = UIAlertController(title: "", message: "You added data to the form. Do you want to discard the changes? Select Cancel to keep working on it.", preferredStyle: .actionSheet)
            let discardAction = UIAlertAction(title: "Discard draft", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                //self.dismiss(animated: true, completion: nil)
            }
            // Add actions to alert controller
            alertController.addAction(discardAction)
            alertController.addAction(cancelAction)
            
            // Presents the alert controller
            present(alertController, animated: true, completion: nil)
            
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cells?.count ?? 0
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
        isModifed = true
    }
    
}

// MARK: - SelectProjectProtocol

extension AddIssueTableViewController: SelectProjectDelegate {
    
    func didSelectdProject(project: Project?) {
        self.project = project
        self.isModifed = true
        // Reload the UI
        updateView()
    }
    
}

// MARK: - Navigation

extension AddIssueTableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the selected project to the Serach Project View Controller
        if segue.identifier == S.searchProject {
            let navigationController = segue.destination as! UINavigationController
            let searchProjectViewController = navigationController.topViewController as! SearchProjectViewController
            searchProjectViewController.selectedProject = project
            searchProjectViewController.delegate = self
        }
        
        if segue.identifier == S.issueType {
            let navigationController = segue.destination as! UINavigationController
            let selectIssueTypeTableViewController = navigationController.topViewController as! SelectIssueTypeTableViewController
            
            selectIssueTypeTableViewController.selectedIssueType = selectedIssueType
            selectIssueTypeTableViewController.delegate = self
        }
        
        if segue.identifier == S.priority {
            let priorityTableController = segue.destination as! PriorityTableViewController
            priorityTableController.selectedPriority = selectedPriority
            priorityTableController.delegate = self
        }
        
        // Prepare for due date segue
        if segue.identifier == S.dueDate {
            prepareForDateCell(segue: segue, date: dueDate, dateType: .dueDate)
        }
        // Prepare for start date segue
        if segue.identifier == S.startDate {
            prepareForDateCell(segue: segue, date: startDate, dateType: .startDate)
        }
        // Prepare for end date segue
        if segue.identifier == S.endDate {
            prepareForDateCell(segue: segue, date: endDate, dateType: .endDate)
        }
        
    }
}

// MARK: - SelectIssueType Delegate

extension AddIssueTableViewController: SelectIssueTypeDelegate {
    
    func didSelectIssueType(issueType: IssueType?) {
        self.selectedIssueType = issueType
        self.isModifed = true
        updateView()
    }
}

// MARK: - UI Table View Delegate

extension AddIssueTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Priority cell
        if Cells?[indexPath.row] == .priority {
            performSegue(withIdentifier: Identifier.SelectPrioritySegue, sender: self)
        }
        // Tap on the attachment cell
        else if Cells?[indexPath.row] == .attachment {
            
            // Add or remove collection cell
            let cell = tableView.cellForRow(at: indexPath) as! AttachmentTableViewCell
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if Cells!.contains(.collection) {
                Cells?.removeAll(where: { (cell) -> Bool in
                    cell == .collection
                })
                cell.isTransform = false
                let nextCell = tableView.cellForRow(at: nextIndexPath)
                // Hide the cell before removing from the table view
                nextCell?.isHidden = true
                tableView.deleteRows(at: [nextIndexPath], with: .automatic)
            } else {
                Cells?.insert(.collection, at: nextIndexPath.row)
                cell.isTransform = true
                tableView.insertRows(at: [nextIndexPath], with: .automatic)
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
           // tableView.reloadData()
        }
        // Tap on due date cell
        else if Cells?[indexPath.row] == .dueDate {
            performSegue(withIdentifier: S.dueDate, sender: self)
        }
        // Tapped on start date cell
        else if Cells?[indexPath.row] == .startDate {
            performSegue(withIdentifier: S.startDate, sender: self)
        }
        // Tapped on end date cell
        else if Cells?[indexPath.row] == .endDate {
            performSegue(withIdentifier: S.endDate, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch Cells?[indexPath.row] {
        case .priority:
            return 70
        case .attachment:
            return 44
        case .collection:
            return 116
        case .dueDate:
            return 70
        case .startDate:
            return 70
        case .endDate:
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
        self.isModifed = true
        updateView()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension AddIssueTableViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let halfScreenPresentationController = HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
        
        halfScreenPresentationController.presentedViewHeight = 230.0
        
        return halfScreenPresentationController
    }
}

// MARK: - SelectDateDelegate

class DateController: SelecteDateDelegate {
    
    var callback: (_ date: Date?)->Void
    
    init(callback: @escaping (_ date: Date?)-> Void) {
        self.callback = callback
    }
    
    func clearDate() {
        self.callback(nil)
    }
    
    func didSelectDate(date: Date) {
        self.callback(date)
    }
    
}

// MARK: - Cell Identifiers, TableCell Emun, DateType Enum

extension AddIssueTableViewController {
    
    private struct CellIdentifier {
        static var prioriy = "PriorityCell"
        static var attachment = "AttachmentCell"
        static var collecion = "CollectionCell"
        static var dueDate = "DueDateCell"
        static var startDate = "StartDateCell"
        static var endDate = "EndDateCell"
    }
    private typealias C = CellIdentifier
    
    private enum CellType {
        case priority
        case attachment
        case collection
        case dueDate
        case startDate
        case endDate
    }

    private enum DateType {
        case dueDate
        case startDate
        case endDate
    }
}

// MARK: - Segue Identifiers

extension AddIssueTableViewController {
    
    private struct SegueIdentifier {
        static let searchProject = "SearchProjectSegue"
        static let issueType = "SelectIssueTypeSegue"
        static let priority = "SelectPrioritySegue"
        static let dueDate = "DueDateSegue"
        static let startDate = "StartDateSegue"
        static let endDate = "EndDateSegue"
    }
    private typealias S = SegueIdentifier
}
