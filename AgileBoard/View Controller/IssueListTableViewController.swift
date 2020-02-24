//
//  IssueListTableViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import NotificationBannerSwift
import SwipeCellKit

class IssueListTableViewController: UITableViewController {
    
    var filter: IssueFilter?
    
    private var sections: [String] = []
    private var sortedIssues: Results<Issue>!
    private lazy var dictionary: Dictionary<String, List<Issue>> = [:]
    
    // Load items partially
    private let numberOfFetchItems: Int = 40
    private var offset: Int = 0
    var reachedEndOfItems = false
    
    // Cell label
    var defaultLabelColor: UIColor?
    
    // Filter issues
    var filteredIssues: Results<Issue>?
    var didFilter = false
    
    let searchController = UISearchController(searchResultsController: nil)
    var isActiveSearch = false
    
    // Issue
    var selectedIssue: Issue?
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view cell
        tableView.register(UINib(nibName: "IssueListTableViewCell", bundle: nil), forCellReuseIdentifier: C.issueCell)
        
        // Remove extra saparetors
        tableView.tableFooterView = UIView()
        
        // Update navigation title
        navigationItem.title = filter?.name
        
        // Sort issue by date
        sortedIssues = filter?.issues
        loadMoreItems()
        
        // Configure search view controller
        configureSearchViewController()
        
        // Add refresh controller
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshItems(_:)), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Auto activate search controller if the isActiveSearch == true
        if isActiveSearch {
            activateSearchControl()
            // Reset the flag
            isActiveSearch = false
        }
       
    }

    // MARK: - Helper Methods
    
    /**
     Arranges an issue into the dictionary
     */
    private func arrange(_ issue: Issue) {
        
        guard let filter = filter else { return }
        
        let sectionKey = filter.sectionFor(issue)
        
        // Create a new section if it does not exist
        if sections.first(where: { $0 == sectionKey }) == nil {
            sections.append(sectionKey)
        }
        
        // Add issue in section
        if dictionary[sectionKey] != nil {
            dictionary[sectionKey]?.append(issue)
        }else {
            let listIssue = List<Issue>()
            listIssue.append(issue)
            dictionary[sectionKey] = listIssue
        }
    }
    
    private func loadMoreItems(){
        reachedEndOfItems = false
        DispatchQueue.main.async {
            self.fetchDataAsync(completion: self.fetchCompletion(items:))
        }
    }
    
    private func fetchCompletion(items: LazyFilterSequence<Results<Issue>>?) {
        if let batchItems = items {
            appendNewData(newItems: batchItems)
        } else {
            print("There are no items found.")
            reachedEndOfItems = true
            
            // reloads the table view if user is searching for issues
            tableView.reloadData()
        }
        refreshControl?.endRefreshing()
    }
    
    private func appendNewData(newItems: LazyFilterSequence<Results<Issue>>) {
        // Arrange new items into sections
        for item in newItems {
            arrange(item)
        }
        
        // Increase offset
        offset += newItems.count
        print("Increased the offset to \(offset).")
        
        // Insert new items into the table view
        tableView.reloadData()
        print("Reloaded the table view.")
    }
    
    private func fetchDataAsync(completion: @escaping (_ items: LazyFilterSequence<Results<Issue>>?)->Void) {
        
        // Determine the fetching range of items
        let start = offset
        let end = offset + numberOfFetchItems
        print("Trying loading item from \(start) to \(end)")
        
        // Find all of items in the above range
        // If user is searching an issue, use filteredIssues;
        // otherwise, use sorted issue
        guard let searchedIssues = isFiltering() ? filteredIssues : sortedIssues else {
            completion(nil)
            return
        }
        
        let batchItems = searchedIssues.filter { (issue) -> Bool in
            if let index = searchedIssues.index(of: issue) {
                return index >= start && index <= end
            }else {
                return false
            }
        }
        
        guard batchItems.count > 0 else {
            print("There are no item in the range.")
            completion(nil)
            return
        }
        
        print("Found: \(batchItems.count) items.")
        
        completion(batchItems)
    }
    
    private func resetDict() {
        offset = 0
        dictionary = [:]
        sections = []
    }
    
    // MARK: - IB Actions
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
         activateSearchControl()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: S.addIssue, sender: self)
    }
    
    @IBAction func refreshItems(_ sender: UIRefreshControl){
        reloadItems()
    }
    
    // MARK: - Configure Search View Controller
    
    func configureSearchViewController() {
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search issue"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        // 6
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sections[section]
        return dictionary[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.issueCell, for: indexPath) as! IssueListTableViewCell
        cell.delegate = self
        
        // Store the default label
        if defaultLabelColor == nil {
            defaultLabelColor = cell.summaryLabel.textColor
        }
        
        let key = sections[indexPath.section]
        
        if let issue = dictionary[key]?[indexPath.row] {
            
            if let status = issue.status, status.markedAsDone == true {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: issue.summary)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.summaryLabel.attributedText = attributeString
                cell.summaryLabel.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
            }else {
                cell.summaryLabel.attributedText =  .none
                cell.summaryLabel.textColor = defaultLabelColor
                cell.summaryLabel.text = issue.summary
            }
            
            cell.issueIdLabel.text = issue.issueID
            
            if let typeImageName = issue.type?.imageName {
                cell.typeImageView.image = UIImage(named: typeImageName)
            }
            if let prioryImageName = issue.priority?.imageName {
                cell.priorityImageView.image = UIImage(named: prioryImageName)
            }
            // Load status color
            if let hexColor = issue.status?.color?.hexColor {
                let color = UIColor(hexString: hexColor)
                cell.statusImageView.image = UIImage(color: color)
                cell.statusImageView.layer.cornerRadius = 3.0
                cell.statusImageView.clipsToBounds = true
            }
            
            cell.statusButton.setTitle(issue.status?.name, for: .normal)
        }
        
        // If it is the last item, loads more items
        if indexPath.section == sections.count - 1,
            indexPath.row == (dictionary[key]?.count ?? 0) - 1, !reachedEndOfItems {
            loadMoreItems()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = sections[indexPath.section]
        if let issue = dictionary[key]?[indexPath.row]{
            selectedIssue = issue
            performSegue(withIdentifier: S.editIssue, sender: self)
        }
        
    }

    // MARK: - Segue Identifier and Cell Identifiers
    
    struct CellIdentifier {
        static let issueCell = "IssueCell"
    }
    typealias C = CellIdentifier
    
    struct SegueIdentifier {
        static let addIssue = "AddIssueSegue"
        static let editIssue = "EditIssueSegue"
    }
    typealias S = SegueIdentifier
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == S.addIssue {
            let navigationController = segue.destination as! UINavigationController
            let vc =  navigationController.topViewController as! IssueDetailTableViewController
            
            let issue = Issue()
            issue.type = .standard
            issue.priority = .standard
            issue.startDate = Date()
            issue.endDate = Date()
            
            vc.delegate = self
            vc.issue = issue
            
        } else if segue.identifier == S.editIssue {
            let navigationController = segue.destination as! UINavigationController
            let vc =  navigationController.topViewController as! IssueDetailTableViewController
            
            guard let project = selectedIssue?.projectOwners.first, let issue = selectedIssue else {
                fatalError("There was something wrong. The project or issue is nil.")
            }
            
            vc.issue = issue
            vc.project = project
            vc.delegate = self
        }
    }
    
    // MARK: - UIScroll View
    
    func activateSearchControl() {
        DispatchQueue.main.async {
            self.searchController.isActive = true
            //self.searchController.searchBar.searchTextField.becomeFirstResponder()
        }
    }
}

// MARK: - UISearchBarDelegate

extension IssueListTableViewController: UISearchBarDelegate {
    
    func isFiltering() -> Bool {
        return searchController.isActive && !isEmptySearchBar()
    }
    
    func isEmptySearchBar() -> Bool {
        return searchController.searchBar.text!.isEmpty
    }
    
    func reloadItems() {
        // Reset the dict
        resetDict()
        
        // Load items
        loadMoreItems()
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filteredIssues = sortedIssues.filter("summary contains[c] %@ OR issueDescription contains[c] %@", searchText.lowercased(), searchText.lowercased())
        
        // User filter the issues list
        didFilter = true
        
        reloadItems()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText: searchText)
    }
    
}

// MARK: - UISearchControllerDelegate

extension IssueListTableViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if didFilter {
            reloadItems()
        }
        // Reset the status
        didFilter = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            searchController.searchBar.becomeFirstResponder()
        }
        
    }
}


// MARK: IssueDetailDelegate

extension IssueListTableViewController: IssueDetailDelegate {
    
    func didAddIssue(with issue: Issue, project: Project?) {
        guard let project = project else {
            fatalError("There was something wrong. The project should not be nil.")
        }
        
        // Set issue's status to the first project's status
        issue.status = project.statuses.first
        
        do{
            try project.add(issue)
        }catch{
            print(error)
            return
        }
        
        // Set issue to selected issue
        self.selectedIssue = issue
        // Add issue to sortedIssues array
        let view: CreatedIssueView = .fromNib()
        view.issueIDLabel.text = issue.issueID
        if let typeImageName = issue.type?.imageName {
            view.typeImageView.image = UIImage(named: typeImageName)
        }
        
        let banner = FloatingNotificationBanner(customView: view)
        banner.show()
        banner.onTap = {
            self.tappedOnBanner()
        }
    }
    
    func tappedOnBanner() {
        performSegue(withIdentifier: S.editIssue, sender: self)
    }
    
}

// MARK: - SwipeTableViewCellDelegate

extension IssueListTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let key = sections[indexPath.section]
               
        guard let issue = dictionary[key]?[indexPath.row] else {
            fatalError("There was something wrong. The issue should NOT be nil.")
        }

        let transAction = SwipeAction(style: .default, title: "Transition") { action, indexPath in
            // transtion issue
            action.fulfill(with: .reset)
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // handel delete action by updating the model here
            self.delete(issue, with: action, indexPath)
        }

        // customize the action appearance

        return [deleteAction,transAction]
    }
    
    func delete(_ issue: Issue, with cellAction: SwipeAction, _ indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Delete Issue", message: "Are you sure you want to delete the issue permanently?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print("Pressed delete action")
            let realm = AppDataController.shared.realm
            do{
                try realm?.write {
                    realm?.delete(issue)
                }
            }catch{
                print(error)
            }
            // Delete issue in dictionary
            let key = self.sections[indexPath.section]
            if let issues = self.dictionary[key] {
                issues.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
