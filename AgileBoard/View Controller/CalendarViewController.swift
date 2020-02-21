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

    let reuseableTableViewCell = "CalendarIssueCell"
    
    var issuesForSelectedDates = List<Issue>()

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
    
    var displayDate: Date {
        guard let date = calendar.date(byAdding: .month, value: 2, to: calendarStartDate) else { return Date() }
        return date
    }
    
    let calendar = Calendar.current
    
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
        let today = Date()
        self.calendarView.setDisplayDate(today, animated: false)
        
        // Select today as default
        calendarView.setDisplayDate(today)
        calendarView.selectDate(today)
        
        // Load events for calendar view
        loadEvents()
    }
    
    // MARK: - IBActions
    
    @IBAction func todayButtonPressed(_ sender: UIBarButtonItem) {
    
        calendarStartDate = defaultStartDate
        calendarEndDate = defaultEndDate
        
        calendarView.reloadData()

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
    
    /**
     Load Events for the calendar from start date to end date
     */
    private func loadEvents() {

        let realm = AppDataController.shared.realm
        
        let dateFrom = startOfDate(for: calendarStartDate)
        let dateTo = endOfDate(for: startOfDate(for: calendarEndDate))
        
        let issues = List<Issue>()
        if let issuesOfDate = realm?.objects(Issue.self).filter("startDate >= %@ AND endDate <= %@", dateFrom, dateTo) {
            issues.append(objectsIn: issuesOfDate)
        }
        
        var events = [CalendarEvent]()
        for issue in issues {
            guard let startDate = issue.startDate,
                    let endDate = issue.endDate else { continue }
            let event = CalendarEvent(title: issue.summary, startDate: startDate, endDate: endDate)
            events.append(event)
        }
        
        calendarView.events = events
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
        tableView.reloadData()
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
    }
    
    func addOneMonth(direction: AddingMonthDirection) {
        
        if direction == .left {
            calendarStartDate = calendar.date(byAdding: .month, value: -1, to: calendarStartDate)
            calendarEndDate = calendar.date(byAdding: .month, value: -1, to: calendarEndDate)
        } else if direction == .right {
            calendarStartDate = calendar.date(byAdding: .month, value: 1, to: calendarStartDate)
            calendarEndDate = calendar.date(byAdding: .month, value: 1, to: calendarEndDate)
        } else {
            fatalError("Invalid case of AddingMonthDirection.")
        }
        
        calendarView.reloadData()
        
    }


    func calendar(_ calendar: CalendarView, didChangeMonthName monthName: String) {
        navigationItem.title = monthName
    }
    
    func calendarDidLoad() {
        calendarView.setDisplayDate(self.displayDate)
        self.loadEvents()
    }
    
    enum AddingMonthDirection {
        case left
        case right
    }
    
}
