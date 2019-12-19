//
//  AddIssueTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/3/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftValidator

protocol IssueDetailDelegate {
    func didAddIssue(with issue: Issue)
    func didModidyIssue(issue: Issue)
}

class IssueDetailTableViewController: UITableViewController {
    
    // MARK: - IB Outlets or View
    
    @IBOutlet weak var createOrSaveButton: UIBarButtonItem!
    var headerView: IssueDetailHeaderView!
    
    // MARK: Properites
        
    /// The current project
    var project: Project?
    /// A list of table view's cell
    private var cells: [CellType]?
    
    /**
     Determines whether users modifed any data in the form.
     `isModifed` is equal `true` if the data was modified; otherwise `false`
    */
    var isModifed: Bool = false
    
    var issue: Issue?
    
    // MARK: Delegate
    
    var delegate: IssueDetailDelegate?
    
    var validator = Validator()
    
    // MARK: Transitionning Delegate
    var dateTransitioningDelegate: DateTransitioningDelegate?
    var statusTrasitioningDelegate: StatusTransitioningDelegate?
    
    /// Determines which text view has been tapped.
    var selectedTextViewTag: Int?
    
    // MARK: Init methods
    
    /**
     Call this method when modifying an existing issue
     
     - Parameters:
        - issue: An issue that you want to modify
        - delegate: Callback functions after adding or modifying an issue
     */
    
    func initView(with issue: Issue, project: Project, delegate: IssueDetailDelegate? = nil) {
        self.delegate = delegate
        self.issue = issue
        self.project = project
        
        createOrSaveButton.title = ""
    }
    
    /**
     Call this method when you want to add a new issue.
     
     - Parameters:
        - project: Initial project of the issue
        - issueType: Initial issue type
        - priority: Initial priority
        - delegate: Callback functions after adding or modifying an issue
     */
    func initView(with project: Project? = nil, issueType: IssueType? = nil, priority: Priority? = nil, startDate: Date?, status: Status? = nil, delegate: IssueDetailDelegate? = nil) {
        issue = Issue()
        issue?.type = issueType
        issue?.priority = priority
        issue?.startDate = startDate
        issue?.status = status
        
        self.project = project
        self.delegate = delegate
        
        createOrSaveButton.title = "Create"
    }
    
    // MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
        updateView(components: [.project, .issueType, .summary, .description, .header, .status])
    }
    
    private func setUpView() {
        // Add tableview's header
        setUpHeader()
        
        // Dismiss the keyboard when dragging on the table view
        tableView.keyboardDismissMode = .onDrag
        
        // Register for Validation
        registerForValidation()
        
        // Display all table cell if user are modifying the issue
        if !isNew() {
            displayTableViewCell(true)
        }
        
    }
    
    private func updateView(components: [ViewComponent], markAsModified: Bool = false) {
        
        // Update project name
        if components.contains(.project), let projectName = project?.name {
            let projectButton = headerView?.projectButton
            projectButton?.isSelected = true
            projectButton?.setTitle(projectName, for: .selected)
        }
        
        // Update issue type
        if components.contains(.issueType), let issueType = issue?.type?.name {
            let typeButton = headerView?.typeButton
            typeButton?.isSelected = true
            typeButton?.setTitle(issueType, for: .selected)
            // Show issue type's icon
            if let issueImageName = issue?.type?.imageName {
                headerView?.typeImageView.image = UIImage(named: issueImageName)
                headerView?.showTypeIcon = true
            }
            else {
                headerView?.showTypeIcon = false
            }
        }
        
        // Reload the table view
        if components.contains(.tableView) {
            tableView.reloadData()
        }
        
        // Update summary
        if components.contains(.summary){
            headerView.summaryTextView.text = issue?.summary
        }
        
        // Update description
        if components.contains(.description){
            headerView.descriptionTextView.text = issue?.issueDescription
        }
        
        // Update header
        if components.contains(.header) {
            headerFitsHeightContent()
        }
        
        // Update status
        if components.contains(.status){
            headerView.statusButton.setTitle(issue?.status?.name ?? "", for: .normal)
            if let color = issue?.status?.color {
                let uiColor = UIColor(hexString: color.hexColor)
                headerView.statusButton.backgroundColor = uiColor
                // invert the text color based on the background color
                headerView.statusButton.setTitleColor(UIColor().textColor(bgColor: uiColor), for: .normal)
            }
        }
        
        // Marks issue as it was modified.
        // Only marks it as true if it is false.
        isModifed = isModifed ? isModifed : markAsModified
    
        // Validate
        validator.validate(self)
    }
    
    // MARK: - Set Up table view header view
    
    private func setUpHeader() {
        headerView = .fromNib()
        headerView.textViewDelagate = self
  
        tableView.tableHeaderView = viewForTableViewHeader()
        
        // Set up actions
        headerView.projectButton.addTarget(self, action: #selector(selectProjectPressed(sender:)), for: .touchUpInside)
        headerView.typeButton.addTarget(self, action: #selector(selectTypePressed(sender:)), for: .touchUpInside)
        headerView.showMoreButton.addTarget(self, action: #selector(showMoreButtonPress(sender:)), for: .touchUpInside)
        headerView.statusButton.addTarget(self, action: #selector(statusPressed(_:)), for: .touchUpInside)
    }
    
    func viewForTableViewHeader()->UIView {
        if isNew() {
            headerView.viewFor(.add)
        } else {
            headerView.viewFor(.edit)
        }
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: headerView.height))
        tableHeaderView.addSubview(headerView)
        return tableHeaderView
    }
    
    // MARK: - Helper Methods
    
    private func cellAt(indexPath: IndexPath) -> UITableViewCell? {
        var cell: UITableViewCell?
        
        switch cells?[indexPath.row] {
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
            priorityCell.priorityNameLabel?.text = issue?.priority?.name
            if let imageName = issue?.priority?.imageName {
                priorityCell.priorityImageView.image = UIImage(named: imageName)
            }
        }
        
        // Attachment Cell
        if let attachmentCell = cell as? AttachmentTableViewCell {
            attachmentCell.numberLabel.text = "\(issue?.attachments.count ?? 0)"
        }
        
        // Collection cell
        if let collectionCell = cell as? AddIssueCollectionTableViewCell {
            let controller = collectionCell.collectionView.controller
            controller?.initView(attachments: issue!.attachments, delegate: self)
        }
        
        // Due date cell
        if let dueDateCell = cell as? DueDateTableViewCell {
            if let date = issue?.dueDate {
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
            if let date = issue?.startDate {
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
            if let date = issue?.endDate {
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
    private func sizeTextViewToFit(textView: UITextView){
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        textView.frame.size =  CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    /**
     Adjusts the table view header to fit the text view height
     */
    private func headerFitsHeightContent() {
        let size = tableView.frame.size
        tableView.tableHeaderView?.frame.size = CGSize(width: size.width, height: headerView.height)
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
                IssueController.shared.update(dueDate: selectedDate!, to: self.issue!)
                break
            case .startDate:
                IssueController.shared.update(startDate: selectedDate!, to: self.issue!)
                break
            case .endDate:
                IssueController.shared.update(endDate: selectedDate!, to: self.issue!)
                break
            }
            self.updateView(components: [.tableView], markAsModified: true)
        })
        // Displays the previous selected date
        selectDateViewController.selectedDate = date
        
        // Set segue transitioning
        dateTransitioningDelegate = DateTransitioningDelegate()
        segue.destination.transitioningDelegate = dateTransitioningDelegate
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
    
    func displayTableViewCell(_ display: Bool) {
        // Remove all cell from the table view
        if !display {
            let indexPaths = cells?.enumerated().compactMap{ IndexPath(row: $0.offset, section: 0)}
            cells = nil
            tableView.deleteRows(at: indexPaths!, with: .none)
        }
        // Add selected cells to the table view
        else {
            cells = [CellType]()
            cells?.append(.priority)
            cells?.append(.attachment)
            cells?.append(.dueDate)
            cells?.append(.startDate)
            cells?.append(.endDate)
            
            tableView.reloadData()
        }
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
        if cells != nil {
           displayTableViewCell(false)
        }
        // Add selected cells to the table view
        else {
            displayTableViewCell(true)
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
        
        guard let header = headerView, let issue = issue else { return }
        issue.summary = header.summaryTextView.text
        issue.issueDescription = header.descriptionTextView.text
        
        if isNew(){
            delegate?.didAddIssue(with: issue)
        }
        // The issue has been modified
        else{
            delegate?.didModidyIssue(issue: issue)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func statusPressed(_ sender: UIButton){
        performSegue(withIdentifier: S.status, sender: self)
    }
    
    @IBAction func tapedOnTextView(_sender: UITextView){
        print("Tapped on text view")
        if !isNew(){
            performSegue(withIdentifier: S.textView, sender: self)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellAt(indexPath: indexPath)!
        
        return cell
    }
    
}

// MARK: - UI TextView Delegate

extension IssueDetailTableViewController: UITextViewDelegate {
    
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
        updateView(components: [.header], markAsModified: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        selectedTextViewTag = textView == headerView.summaryTextView ? 0 : 1
        if !isNew(){
            performSegue(withIdentifier: S.textView, sender: self)
        }
        
        return isNew() ? true : false
    }
}

// MARK: - SelectProjectProtocol

extension IssueDetailTableViewController: SelectProjectDelegate {
    
    func didSelectdProject(project: Project?) {
        self.project = project
        updateView(components: [.project], markAsModified: true)
    }
    
}

// MARK: - Navigation

extension IssueDetailTableViewController {

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
            
            selectIssueTypeTableViewController.selectedIssueType = issue?.type
            selectIssueTypeTableViewController.delegate = self
        }
        
        if segue.identifier == S.priority {
            let priorityTableController = segue.destination as! PriorityTableViewController
            priorityTableController.selectedPriority = issue?.priority
            priorityTableController.delegate = self
        }
        
        // Prepare for due date segue
        if segue.identifier == S.dueDate {
            prepareForDateCell(segue: segue, date: issue?.dueDate, dateType: .dueDate)
        }
        // Prepare for start date segue
        if segue.identifier == S.startDate {
            prepareForDateCell(segue: segue, date: issue?.startDate, dateType: .startDate)
        }
        // Prepare for end date segue
        if segue.identifier == S.endDate {
            prepareForDateCell(segue: segue, date: issue?.endDate, dateType: .endDate)
        }
        
        // Prare for status segue
        if segue.identifier == S.status {
            let navigationController = segue.destination as! UINavigationController
            let statusTableViewController = navigationController.topViewController as! StatusTableViewController
            statusTableViewController.statuses = project?.statuses
            statusTableViewController.selectedStatus = issue?.status
            statusTableViewController.delegate = self
            
            statusTrasitioningDelegate = StatusTransitioningDelegate()
            segue.destination.transitioningDelegate = statusTrasitioningDelegate
            segue.destination.modalPresentationStyle = .custom
        }
        
        if segue.identifier == S.textView {
            let navigationController = segue.destination as! UINavigationController
            let textViewTableViewController = navigationController.topViewController as! TextviewTableViewController
            
            textViewTableViewController.delegate = self
            textViewTableViewController.selectedTextViewTag  = selectedTextViewTag
            textViewTableViewController.issue = issue
        }
        
    }
}

// MARK: - SelectIssueType Delegate

extension IssueDetailTableViewController: SelectIssueTypeDelegate {
    
    func didSelectIssueType(issueType: IssueType?) {
        self.issue?.type = issueType
        updateView(components: [.issueType], markAsModified: true)
    }
}

// MARK: - UI Table View Delegate

extension IssueDetailTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Priority cell
        if cells?[indexPath.row] == .priority {
            performSegue(withIdentifier: Identifier.SelectPrioritySegue, sender: self)
        }
        // Tap on the attachment cell
        else if cells?[indexPath.row] == .attachment {
            
            // Add or remove collection cell
            let cell = tableView.cellForRow(at: indexPath) as! AttachmentTableViewCell
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if cells!.contains(.collection) {
                cells?.removeAll(where: { (cell) -> Bool in
                    cell == .collection
                })
                cell.isTransform = false
                let nextCell = tableView.cellForRow(at: nextIndexPath)
                // Hide the cell before removing from the table view
                nextCell?.isHidden = true
                tableView.deleteRows(at: [nextIndexPath], with: .automatic)
            } else {
                cells?.insert(.collection, at: nextIndexPath.row)
                cell.isTransform = true
                tableView.insertRows(at: [nextIndexPath], with: .automatic)
            }
            tableView.deselectRow(at: indexPath, animated: true)
            
           // tableView.reloadData()
        }
        // Tap on due date cell
        else if cells?[indexPath.row] == .dueDate {
            performSegue(withIdentifier: S.dueDate, sender: self)
        }
        // Tapped on start date cell
        else if cells?[indexPath.row] == .startDate {
            performSegue(withIdentifier: S.startDate, sender: self)
        }
        // Tapped on end date cell
        else if cells?[indexPath.row] == .endDate {
            performSegue(withIdentifier: S.endDate, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cells?[indexPath.row] {
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

extension IssueDetailTableViewController: SelectPriorityDelegate {
    
    func didSelectPriority(priority: Priority) {
        if let issue = issue {
            IssueController.shared.update(priority, to: issue)
            updateView(components: [.tableView], markAsModified: true)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension IssueDetailTableViewController {
    
    class DateTransitioningDelegate: UIViewController, UIViewControllerTransitioningDelegate {
        
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            
            let halfScreenPresentationController = HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
            
            halfScreenPresentationController.presentedViewHeight = 230.0
            
            return halfScreenPresentationController
        }
    }
    
    class StatusTransitioningDelegate: UIViewController, UIViewControllerTransitioningDelegate {
        
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            
            let halfScreenPresentationController = HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
            
            halfScreenPresentationController.presentedViewHeight = view.frame.height/2
            halfScreenPresentationController.presentedCornerRadius = 10.0
            
            return halfScreenPresentationController
        }
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

extension IssueDetailTableViewController {
    
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

extension IssueDetailTableViewController {
    
    private struct SegueIdentifier {
        static let searchProject = "SearchProjectSegue"
        static let issueType = "SelectIssueTypeSegue"
        static let priority = "SelectPrioritySegue"
        static let dueDate = "DueDateSegue"
        static let startDate = "StartDateSegue"
        static let endDate = "EndDateSegue"
        static let status = "StatusSegue"
        static let textView = "TextViewSegue"
    }
    private typealias S = SegueIdentifier
}

// MARK: - View Components

extension IssueDetailTableViewController {
    private enum ViewComponent {
        case project
        case issueType
        case priority
        case tableView
        case header
        case summary
        case description
        case status
    }
}

// MARK: - AttachmentDelegate

extension IssueDetailTableViewController: AttachmentDelegate {
    func didAddAttachment(attachment: Attachment) {
        if let issue = issue {
            IssueController.shared.add(attachment, to: issue)
            updateView(components: [.tableView], markAsModified: true)
        }
    }
    
    func didDeleteAttachment(attachment: Attachment, at indexPath: IndexPath) {
        IssueController.shared.delete(attachment)
        updateView(components: [.tableView], markAsModified: true)
    }
}

// MARK: - Validations

extension IssueDetailTableViewController: ValidationDelegate {

    private func registerForValidation() {
        // The Done button only appears after user inputted the project, issue type and summary
        
        if let header = headerView {
            validator.registerField(header.summaryTextView, rules: [RequiredRule()])
        }
        
    }
    
    func validationSuccessful() {
        // Only enable the button when the validation has been successfully
        // and the isMofied flag has been marked as modified.
        createOrSaveButton.isEnabled = isModifed && isNew()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        createOrSaveButton.isEnabled = false
    }
}

// MARK: - Status Delegate

extension IssueDetailTableViewController: StatusDelegate {
    func didSelectStatus(status: Status) {
        if let issue = issue{
            IssueController.shared.update(status, to: issue)
            updateView(components: [.status])
        }
    }
}

// MARK: - TextViewTableView Delegate

extension IssueDetailTableViewController: TextViewTableViewDelegate {
    func issueDidChange(issue: Issue) {
        updateView(components: [.summary, .description], markAsModified: true)
    }
}
