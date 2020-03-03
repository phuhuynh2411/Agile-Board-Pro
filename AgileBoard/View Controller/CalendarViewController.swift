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
    @IBOutlet weak var stackView: UIStackView!
    
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
        
    let addIssueSegue   = "AddIssueSegue"
    let editIssueSegue  = "EditIssueSegue"
    let issueListSegue  = "IssueListSegue"
    
    let realm = AppDataController.shared.realm
    
    var selectedIssue: Issue?
    
    let refreshControler = UIRefreshControl()
    
    private var isSelectedToday = false
    
    internal var statusTrasitioningDelegate: StatusTransitioningDelegate?
       
    internal let changeStatueSegue = "ChangeStatusSegue"
       
    internal var editedIndexPaths = [IndexPath]()
    
    // MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.dataSource                 = self
        calendarView.delegate                   = self
        calendarView.multipleSelectionEnable    = false
        
        tableView.dataSource        = self
        tableView.delegate          = self
        
        tableView.register(IssueCalendarTableViewCell.self, forCellReuseIdentifier: reuseableTableViewCell)
        
        calendarStartDate = defaultStartDate
        calendarEndDate = defaultEndDate
    
        refreshControler.addTarget(self, action: #selector(refreshTableView(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControler
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustView()
        
        if !isSelectedToday { self.goToToday() }
    }
    
    private func adjustView() {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            // activate landscape changes
            stackView.axis = .horizontal
        } else {
            // activate portrait changes
            stackView.axis = .vertical
        }
        self.view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    
    @IBAction func todayButtonPressed(_ sender: UIBarButtonItem) {
        self.goToToday()
    }
    
    private func goToToday() {
        self.displayDate = Date()
        calendarView.setDisplayDate(self.displayDate)
        
        loadIssues(forMonth: self.displayDate)
        
        // After the view is loaded, selects today as selected date
        // however, only selects once times.
        guard !isSelectedToday else { return }
        calendarView.selectDate(self.displayDate)
        isSelectedToday = true
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: addIssueSegue, sender: self)
    }
    
    @IBAction func refreshTableView(_ sender: UIRefreshControl){
        tableView.reloadData()
        reloadIssuesForCurrentMonth()
        
        refreshControler.endRefreshing()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: self.issueListSegue, sender: self)
    }
    
    // MARK: - Private Methods
    
    /**
     Reload issues for the selected dates
     
     Loads issues that have the start date or due date within the current date.
     */
    private func loadIssuesForSelectedDates() {
                        
        var predicates = [NSPredicate]()
        
        for date in calendarView.selectedDates {
            let dateFrom = startOfDate(for: date)
            let dateTo = endOfDate(for: dateFrom)
   
            let predicate = NSPredicate(format: "startDate >= %@ AND startDate <= %@", argumentArray: [dateFrom, dateTo])
            predicates.append(predicate)
            
        }
        
        if predicates.count > 0 {
            let compoundPredicates = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
            self.issuesForSelectedDates = realm?.objects(Issue.self).filter(compoundPredicates).sorted(byKeyPath: "createdDate", ascending: false)
        } else {
            // Create an empty result
            self.issuesForSelectedDates = realm?.objects(Issue.self).filter(NSPredicate(value: false))
        }
     
        //self.updateBadge()
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
        DispatchQueue.main.async {
            self.loadIssuesForSelectedDates()
            
            // Add or remove table footer view
            self.tableView.tableFooterView =  self.issuesForSelectedDates?.count ?? 0 > 0 ? UIView() : self.tableFooterView
            
            self.tableView.reloadData()
        }
    }
    
    /**
     Load all issues from the first date of the month to the last date.
     
     - Parameters:
        - dateInMonth: Any date in the month.
     */
    private func loadIssues(forMonth dateInMonth: Date) {
                
        let startOfMonth = self.startOfMonth(fromDate: dateInMonth)
        let endOfMonth = self.endOfMonth(fromDate: dateInMonth)
        
        let dateFrom = startOfDate(for: startOfMonth)
        let dateTo = endOfDate(for: startOfDate(for: endOfMonth))
        
        if let issuesOfDate = realm?.objects(Issue.self).filter("startDate >= %@ AND endDate <= %@", dateFrom, dateTo) {
            
            var eventsForMonths = [CalendarEvent]()

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
    
    /**
     Show the number of due issues on the tab bar badge
     */
    private func updateBadge() {
        // Add the badge to the tab bar to show a number of due issues.
        let numberOfDueIssues = issuesForSelectedDates?.filter({ (issue) -> Bool in
            guard let dueDate = issue.dueDate else { return false }
            return self.calendar.isDate(dueDate, inSameDayAs: Date())
            }).count
        if  let tabItems = tabBarController?.tabBar.items,
            let count = numberOfDueIssues {
            let tabItem = tabItems[2]
            tabItem.badgeValue = count > 0 ? "\(count)" : nil
        }
    }
    
    /**
     Reload all issues for the current month.
     */
    private func reloadIssuesForCurrentMonth() {
        guard let displayDate = calendarView.displayDate else { return }
        DispatchQueue.main.async {
            self.loadIssues(forMonth: displayDate)
            self.calendarView.reloadData()
        }
    }
    
    // MARK: - Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.addIssueSegue {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! IssueDetailTableViewController
            
            // If the user selected a date, sets the start date and end date to that selected date
            // otherwise, set the start date and end date to first date of the display month
            guard let displayDate = calendarView.displayDate else { return }
            var startDate: Date
            if let  date = calendarView.selectedDates.first,
                    calendar.isDate(date, equalTo: displayDate, toGranularity: .month) {
                
                startDate = date
            } else {
                startDate = self.startOfMonth(fromDate: displayDate)
            }
            let endDate = startDate
    
            let issue = Issue()
            issue.type = .standard
            issue.priority = .standard
            issue.startDate = startDate
            issue.endDate = endDate
            
            vc.delegate = self
            vc.issue = issue
            
        } else if segue.identifier == self.editIssueSegue {
            let navigationController = segue.destination as! UINavigationController
            let vc =  navigationController.topViewController as! IssueDetailTableViewController
            
            guard let project = selectedIssue?.projectOwners.first, let issue = selectedIssue else {
                fatalError("There was something wrong. The project or issue is nil.")
            }
            
            vc.issue = issue
            vc.project = project
            vc.delegate = self
            
        } else if segue.identifier == self.issueListSegue {
            let  issueListTableViewController = segue.destination as! IssueListTableViewController
            issueListTableViewController.filter = AllIssueFilter(name: "All", imageName: "")
            issueListTableViewController.isActiveSearch = true // isActiveSearch
            
        } else if segue.identifier == "ChangeStatusSegue" {
            let navigationController = segue.destination as! UINavigationController
            let vc = navigationController.topViewController as! StatusTableViewController
            
            let project = selectedIssue?.projectOwners.first
            vc.project = project
            vc.statuses = project?.statuses
            vc.selectedStatus = selectedIssue?.status
            
            vc.delegate = self
            
            statusTrasitioningDelegate = StatusTransitioningDelegate()
            segue.destination.transitioningDelegate = statusTrasitioningDelegate
            segue.destination.modalPresentationStyle = .custom
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
    
    func didAdd(_ issue: Issue, to project: Project?) {
        issue.status = project?.statuses.first
        do{
            try project?.add(issue)
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
        reloadIssuesForCurrentMonth()
    }
    
    func didModify(_ issue: Issue) {
        tableView.reloadData()
        reloadIssuesForCurrentMonth()
    }
    
}
