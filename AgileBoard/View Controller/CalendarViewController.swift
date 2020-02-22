//
//  CalendarViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/5/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class CalendarViewController: UIViewController {
    
    // IBOutlets
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    
    var calendarStartDate: Date!
    var calendarEndDate: Date!

    let reuseableTableViewCell  = "CalendarIssueCell"
    
    var issuesForSelectedDates  = List<Issue>()
    var issues                  = List<Issue>()

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
        calendarView.selectDate(displayDate)
        calendarView.setDisplayDate(displayDate)
        
        loadIssues(forMonth: self.displayDate)
    }
    
    // MARK: - Private Methods
    
    private func reloadIssuesForSelectedDates() {
        
        let realm = AppDataController.shared.realm
        
        let selectedDates = calendarView.selectedDates
        issuesForSelectedDates.removeAll()
        for date in selectedDates {
            let dateFrom = startOfDate(for: date)
            let dateTo = endOfDate(for: dateFrom)
            
            if let issuesOfDate = realm?.objects(Issue.self).filter("startDate >= %@ AND endDate <= %@ ", dateFrom, dateTo) {
                issuesForSelectedDates.append(objectsIn: issuesOfDate)
            }
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
        tableView.tableFooterView =  issuesForSelectedDates.count > 0 ? UIView() : self.tableFooterView
        
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
        
        print("Did scroll to month \(date)")
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
