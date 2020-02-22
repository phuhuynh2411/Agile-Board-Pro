//
//  CalendarViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/5/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift
import NotificationBannerSwift

class CalendarViewController: UIViewController {
    
    // IBOutlets
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    
    var calendarStartDate: Date!
    var calendarEndDate: Date!

    let reuseableTableViewCell  = "CalendarIssueCell"
    
    var issuesForSelectedDates  : Results<Issue>?
    var issues                  : Results<Issue>?

    var defaultStartDate: Date {
        let today = Date()
        guard let date = calendar.date(byAdding: .month, value: -2, to: today) else { return today }
        return date
    }
    
    var defaultEndDate: Date {
        let today = Date()
        guard let date = calendar.date(byAdding: .month, value: 2, to: today) else { return today }
        return date
    }
    
    var afterStartDate: Date {
        guard let date = calendar.date(byAdding: .month, value: 1, to: calendarStartDate) else { return Date() }
        return date
    }
    
    var beforeEndDate: Date {
        guard let date = calendar.date(byAdding: .month, value: -1, to: calendarEndDate) else { return Date() }
        return date
    }
    
    var displayDate: Date = {
        return Date()
    }()
    
    let calendar = Calendar.current
    
    var tableFooterView: UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
        label.text = "No Issues"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .officialApplePlaceholderGray
        return label
    }
    
    var issuesForMonths = [Date: Results<Issue>]()
    var eventsForMonths = [CalendarEvent]()
    
    let addIssueSegue   = "AddIssueSegue"
    let editIssueSegue  = "EditIssueSegue"
    let issueListSegue  = "IssueListSegue"
    
    let realm = AppDataController.shared.realm
    
    var selectedIssue: Issue?
    
    let refreshControler = UIRefreshControl()
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.dataSource     = self
        calendarView.delegate       = self
        
        tableView.dataSource        = self
        tableView.delegate          = self
        
        tableView.register(IssueCalendarTableViewCell.self, forCellReuseIdentifier: reuseableTableViewCell)
        
        calendarStartDate = defaultStartDate
        calendarEndDate = defaultEndDate
    
        refreshControler.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControler
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.goToToday()
    }
    
    // MARK: - IBActions
    
    @IBAction func todayButtonPressed(_ sender: UIBarButtonItem) {
        self.goToToday()
    }
    
    private func goToToday() {
        self.displayDate = Date()
        calendarView.setDisplayDate(displayDate)
        
        loadIssues(forMonth: self.displayDate)
        
        if !calendarView.selectedDates.contains(where: { calendar.isDate(self.displayDate, inSameDayAs: $0) } ){
            calendarView.selectDate(self.displayDate)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: addIssueSegue, sender: self)
    }
    
    @IBAction func refreshTableView(_ sender: UIRefreshControl){
        tableView.reloadData()
        refreshControler.endRefreshing()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: self.issueListSegue, sender: self)
    }
    
    // MARK: - Private Methods
    
    private func reloadIssuesForSelectedDates() {
                        
        var predicates = [NSPredicate]()
        
        for date in calendarView.selectedDates {
            let dateFrom = startOfDate(for: date)
            let dateTo = endOfDate(for: dateFrom)
   
            let predicate = NSPredicate(format: "startDate >= %@ AND endDate <= %@ ", argumentArray: [dateFrom, dateTo])
            predicates.append(predicate)
            
        }
        
        if predicates.count > 0 {
            let compoundPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            self.issuesForSelectedDates = realm?.objects(Issue.self).filter(compoundPredicates).sorted(byKeyPath: "createdDate", ascending: false)
        } else {
            // Create an empty result
            self.issuesForSelectedDates = realm?.objects(Issue.self).filter(NSPredicate(value: false))
        }
        
    }
    
    private func startOfDate(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    private func endOfDate(for date: Date) -> Date {
        let calendar = Calendar.current
        guard let endOfDate = calendar.date(byAdding: .day, value: 1, to: date) else { return Date() }
        return endOfDate
    }
    
    /**
     Reload the issues on the table view
     */
    private func reloadIssues() {
        reloadIssuesForSelectedDates()
        
        // Add or remove table footer view
        tableView.tableFooterView =  issuesForSelectedDates?.count ?? 0 > 0 ? UIView() : self.tableFooterView
        
        tableView.reloadData()
    }
    
    private func loadIssues(forMonth dateInMonth: Date) {
        
        let realm = AppDataController.shared.realm
        
        let startOfMonth = self.startOfMonth(fromDate: dateInMonth)
        let endOfMonth = self.endOfMonth(fromDate: dateInMonth)
        
        let dateFrom = startOfDate(for: startOfMonth)
        let dateTo = endOfDate(for: startOfDate(for: endOfMonth))
        
        guard issuesForMonths[startOfMonth] == nil else { return }
        
        if let issuesOfDate = realm?.objects(Issue.self).filter("startDate >= %@ AND endDate <= %@", dateFrom, dateTo) {
            issuesForMonths[startOfMonth] = issuesOfDate
        
            for issue in issuesOfDate {
                guard let startDate = issue.startDate,
                    let endDate = issue.endDate else { continue }
                let event = CalendarEvent(title: issue.summary, startDate: startDate, endDate: endDate)
                eventsForMonths.append(event)
            }
            
            calendarView.events = eventsForMonths
        }
    }
    
    func startOfMonth(fromDate: Date)-> Date {
        let dateComponents = calendar.dateComponents([.month, .year], from: fromDate)
        return calendar.date(from: dateComponents)!
    }

    func endOfMonth(fromDate: Date)-> Date {
        // Add one month and substract one day
        let start = startOfMonth(fromDate: fromDate)
        let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: start)!
        
        return calendar.date(byAdding: .day, value: -1, to: startOfNextMonth)!
    }
    
    private func tappedOnBanner() {
        self.performSegue(withIdentifier: self.editIssueSegue, sender: self)
    }
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.addIssueSegue {
            let navigationController = segue.destination as! UINavigationController
            let issueDetailTableViewController = navigationController.topViewController as! IssueDetailTableViewController
            
            issueDetailTableViewController.initView(with: nil, issueType: IssueTypeController.shared.default(), priority: PriorityController.shared.default(),startDate: Date(), status: nil, delegate: self)
        } else if segue.identifier == self.editIssueSegue {
            let navigationController = segue.destination as! UINavigationController
            let issueDetailTableViewController =  navigationController.topViewController as! IssueDetailTableViewController
            
            guard let project = selectedIssue?.projectOwners.first, let issue = selectedIssue else {
                fatalError("There was something wrong. The project or issue is nil.")
            }
            issueDetailTableViewController.initView(with: issue, project: project, delegate: self)
        } else if segue.identifier == self.issueListSegue {
            let  issueListTableViewController = segue.destination as! IssueListTableViewController
            issueListTableViewController.filter = AllIssueFilter(name: "All", imageName: "")
            issueListTableViewController.isActiveSearch = true // isActiveSearch
        }
    }
}

// MARK: - CalendarViewDataSource

extension CalendarViewController: CalendarViewDataSource {
    
    func startDate() -> Date {
        return calendarStartDate
    }

    func endDate() -> Date {
        return calendarEndDate
    }
    
}

// MARK: - CalendarViewDelegate

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
       reloadIssues()
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        reloadIssues()
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        if  self.calendar.isDate(date, equalTo: afterStartDate, toGranularity: .month) {
            addOneMonth(direction: .left)
        } else if self.calendar.isDate(date, equalTo: beforeEndDate, toGranularity: .month) {
            addOneMonth(direction: .right)
        }
        
        loadIssues(forMonth: date)
    }
    
    func addOneMonth(direction: AddingMonthDirection) {
        
        if direction == .left {
            guard let moveToDate = calendar.date(byAdding: .month, value: 2, to: calendarStartDate) else { return }
            self.calendarView.setDisplayDate(moveToDate)
            
            displayDate = afterStartDate
            calendarStartDate = calendar.date(byAdding: .month, value: -1, to: calendarStartDate)
        } else if direction == .right {
            calendarEndDate = calendar.date(byAdding: .month, value: 1, to: calendarEndDate)
        } else {
            fatalError("Invalid case of AddingMonthDirection.")
        }
        
        calendarView.reloadData {
            if direction == .left {
                self.calendarView.setDisplayDate(self.displayDate)
            }
        }
    }


    func calendar(_ calendar: CalendarView, didChangeMonthName monthName: String) {
        navigationItem.title = monthName
    }
    
    func calendarDidLoad() {
        
    }
    
    enum AddingMonthDirection {
        case left
        case right
    }
    
}

extension CalendarViewController: IssueDetailDelegate {
    
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
        }
        
        let view: CreatedIssueView = .fromNib()
        view.issueIDLabel.text = issue.issueID
        if let typeImageName = issue.type?.imageName {
            view.typeImageView.image = UIImage(named: typeImageName)
        }
        
        self.selectedIssue = issue
        
        let banner = FloatingNotificationBanner(customView: view)
        banner.show()
        banner.onTap = {
            self.tappedOnBanner()
        }
        
        tableView.reloadData()
    }
    
}
