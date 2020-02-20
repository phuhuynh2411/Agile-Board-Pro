//
//  CalendarViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/5/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    // IBOutlets
    
    @IBOutlet weak var calendarView: CalendarView!
    
    // Properties
    
    var calendarEndDate: Date?
    var calendarStartDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.dataSource     = self
        calendarView.delegate       = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        self.calendarView.setDisplayDate(today, animated: false)
    }
    
    // MARK: - IBActions
    
    @IBAction func todayButtonPressed(_ sender: UIBarButtonItem) {
  
        let todayDate = Date()
        guard   let startDate = calendarStartDate,
                let centerDate = calendarView.calendar.date(byAdding: .month, value: 2, to: startDate) else { return }
        
        
        calendarStartDate = dateForStartDate
        calendarEndDate = dateForEndDate
        
        calendarView.reloadData()
        
        calendarView.setDisplayDate(centerDate, animated: false)
        calendarView.displayDateOnHeader(todayDate)
               
    }
    
}

// MARK: - CalendarViewDataSource

extension CalendarViewController: CalendarViewDataSource {
    
    var dateForStartDate: Date {
        var dateComponents = DateComponents()
        dateComponents.month = -2
        let today = Date()
        guard let startDate = self.calendarView.calendar.date(byAdding: dateComponents, to: today) else { return today }
        calendarStartDate = startDate
        return startDate
    }
    
    var dateForEndDate: Date {
        var dateComponents = DateComponents()
        dateComponents.month = 2
        let today = Date()
        guard let endDate = self.calendarView.calendar.date(byAdding: dateComponents, to: today) else { return today }
        calendarEndDate = endDate
        return endDate
    }
    
    func startDate() -> Date {
        if let startDate = calendarStartDate {
            return startDate
        } else {
            return dateForStartDate
        }
    }

    func endDate() -> Date {
        if let endDate = calendarEndDate {
            return endDate
        } else {
            return dateForEndDate
        }
    }
    
}

// MARK: - CalendarViewDelegate

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {

        // If the date is equal the start date of the calendar
        // Decreases one month on the start and end date
        guard   let startDate = calendarStartDate,
                let endDate = calendarEndDate,
                let dateAfterStart = calendarView.calendar.date(byAdding: .month, value: 1, to: startDate),
                let dateBeforeEnd = calendarView.calendar.date(byAdding: .month, value: -1, to: endDate) else { return }
        
        if calendarView.calendar.isDate(date, equalTo: dateAfterStart, toGranularity: .month) {
            addOneMonth(direction: .left)
        } else if calendarView.calendar.isDate(date, equalTo: dateBeforeEnd, toGranularity: .month) {
            addOneMonth(direction: .right)
        }
        
    }
    
    func addOneMonth(direction: AddingMonthDirection) {
        let calendar = calendarView.calendar
        
        guard   let startDate = calendarStartDate,
                let endDate = calendarEndDate,
                let dateAfterStart = calendarView.calendar.date(byAdding: .month, value: 1, to: startDate),
                let dateBeforeEnd = calendarView.calendar.date(byAdding: .month, value: -1, to: endDate),
                let centerDate = calendarView.calendar.date(byAdding: .month, value: 2, to: startDate) else { return }
        
        var dateOnHeader: Date!
        
        if direction == .left {
            calendarStartDate = calendar.date(byAdding: .month, value: -1, to: startDate)
            calendarEndDate = calendar.date(byAdding: .month, value: -1, to: endDate)
            
            dateOnHeader = dateAfterStart
        } else if direction == .right {
            calendarStartDate = calendar.date(byAdding: .month, value: 1, to: startDate)
            calendarEndDate = calendar.date(byAdding: .month, value: 1, to: endDate)
            
            dateOnHeader = dateBeforeEnd
        } else {
            fatalError("Invalid case of AddingMonthDirection.")
        }
        
        calendarView.reloadData()
        
        calendarView.setDisplayDate(centerDate, animated: false)
        calendarView.displayDateOnHeader(dateOnHeader)
        
    }


    func calendar(_ calendar: CalendarView, didChangeMonthName monthName: String) {
        navigationItem.title = monthName
    }
    
    enum AddingMonthDirection {
        case left
        case right
    }
    
}
