//
//  CalendarViewController.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/5/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: CalendarView!
    var calendarEndDate: Date?
    var calendarStartDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.dataSource     = self
        calendarView.delegate       = self
        calendarView.autoAddMonth   = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        self.calendarView.setDisplayDate(today, animated: false)
    }
    
}

// MARK: - CalendarViewDataSource

extension CalendarViewController: CalendarViewDataSource {
    
    func startDate() -> Date {
        if let startDate = calendarStartDate {
            return startDate
        } else {
            var dateComponents = DateComponents()
            dateComponents.month = -1
            let today = Date()
            let startDate = self.calendarView.calendar.date(byAdding: dateComponents, to: today)
            calendarStartDate = startDate
            return startDate!
        }
    }

    func endDate() -> Date {
        if let endDate = calendarEndDate {
            return endDate
        } else {
            var dateComponents = DateComponents()
            dateComponents.month = 1
            let today = Date()
            let endDate = self.calendarView.calendar.date(byAdding: dateComponents, to: today)
            calendarEndDate = endDate
            return endDate!
        }
    }
    
}

// MARK: - CalendarViewDelegate

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        print("Did selecte date with events.")
    }
    
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        print("Did select a date")
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        print("Did scroll to the month date: \(date).")
    }
    
    func calendar(_ calendar: CalendarView, didAddNextMonth endDate: Date) {
        calendarEndDate = endDate
    }
    
    func calendar(_ calendar: CalendarView, didAddPreviousMonth startDate: Date) {
        calendarStartDate = startDate
    }


    
}
