//
//  CalendarExtension.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 1/9/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import Foundation

extension Calendar {
    private var currentDate: Date { return Date() }
    private var lastWeekDate: Date {
        self.date(byAdding: .day, value: -7, to: currentDate)!
    }
    private var lastMonthDate: Date {
        self.date(byAdding: .month, value: -1, to: currentDate)!
    }
    
    func isDateInThisWeek(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
    }
    
    func isDateInLastWeek(_ date: Date) -> Bool {
           return isDate(date, equalTo: lastWeekDate, toGranularity: .weekOfYear)
    }
    
    func isDateInThisMonth(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .month)
    }
    
    func isDateInLastMonth(_ date: Date) -> Bool {
           return isDate(date, equalTo: lastMonthDate, toGranularity: .month)
    }
    
    func isDateInNextWeek(_ date: Date) -> Bool {
        guard let nextWeek = self.date(byAdding: DateComponents(weekOfYear: 1), to: currentDate) else {
            return false
        }
        return isDate(date, equalTo: nextWeek, toGranularity: .weekOfYear)
    }
    
    func isDateInNextMonth(_ date: Date) -> Bool {
        guard let nextMonth = self.date(byAdding: DateComponents(month: 1), to: currentDate) else {
            return false
        }
        return isDate(date, equalTo: nextMonth, toGranularity: .month)
    }
    
    func isDateInFollowingMonth(_ date: Date) -> Bool {
        guard let followingMonth = self.date(byAdding: DateComponents(month: 2), to: currentDate) else {
            return false
        }
        return isDate(date, equalTo: followingMonth, toGranularity: .month)
    }
    
    public func thisSunday(_ date: Date)->Date{
        let calendar = self
        let dayofWeek = calendar.component(.weekday, from: date)
        
        switch dayofWeek {
        case 1:
            return date
        default:
            return calendar.date(byAdding: .day, value: 8 - dayofWeek, to: date)!
        }
    }
    
    var startOfWeek: Date? {
        let calendar = self
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else { return nil }
        return calendar.date(byAdding: .day, value: 1, to: sunday)
    }

    var endOfWeek: Date? {
        let calendar = self
        guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else { return nil }
        return calendar.date(byAdding: .day, value: 7, to: sunday)
    }
    
    var dateFrom: Date {
        return self.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
    }
    var dateTo: Date {
        return self.date(byAdding: .day, value: 1, to: dateFrom)!
    }
}
