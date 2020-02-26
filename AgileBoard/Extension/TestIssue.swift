//
//  ProjectTest.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/25/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

class TestIssue {
    
    private var project: Project

    init(project: Project){
        self.project = project
    }
    
    var issues: [Issue] {
    
        let lastThreeMonth = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .todo(of: project), type: .story, priority: .medium, createdDate: TestDate.inLastThreeMonth, startDate: TestDate.today, endDate: TestDate.today, dueDate: .none)
        
        let lastTwoMonth = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .todo(of: project), type: .story, priority: .medium, createdDate: TestDate.inLastTwoMonth, startDate: TestDate.inLastTwoMonth, endDate: TestDate.inLastTwoMonth, dueDate: .none)

        let lastMonth = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .inprogress(of: project), type: .story, priority: .medium, createdDate: TestDate.lastMonth, startDate: TestDate.lastMonth, endDate: TestDate.lastMonth, dueDate: .none)
        
        let lastWeek = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .inprogress(of: project), type: .story, priority: .medium, createdDate: TestDate.lastWeek, startDate: TestDate.lastWeek, endDate: TestDate.lastWeek, dueDate: .none)
        
         let thisWeek = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .done(of: project), type: .story, priority: .medium, createdDate: TestDate.thisWeek, startDate: TestDate.thisWeek, endDate: TestDate.thisWeek, dueDate: .none)
        
        let yesterday = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .todo(of: project), type: .story, priority: .medium, createdDate: TestDate.yesterday, startDate: TestDate.yesterday, endDate: TestDate.yesterday, dueDate: .none)
        
        let today = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .done(of: project), type: .story, priority: .medium, createdDate: TestDate.today, startDate: TestDate.today, endDate: TestDate.today, dueDate: .none)
        
        let dueToday = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .todo(of: project), type: .story, priority: .medium, createdDate: TestDate.today, startDate: TestDate.today, endDate: TestDate.today, dueDate: TestDate.today)
        
        let dueTomorrow = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .todo(of: project), type: .story, priority: .medium, createdDate: TestDate.today, startDate: TestDate.today, endDate: TestDate.today, dueDate: TestDate.tomorrow)
        
        let dueInNextTwoDays = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .todo(of: project), type: .story, priority: .medium, createdDate: TestDate.today, startDate: TestDate.today, endDate: TestDate.today, dueDate: TestDate.inNextTwoDays)
        
        let nextMonth = Issue(summary: Lorem.sentences(1), description: Lorem.sentences(3), status: .todo(of: project), type: .story, priority: .medium, createdDate: TestDate.today, startDate: TestDate.nextMonth, endDate: TestDate.nextMonth, dueDate: TestDate.nextMonth)
    
        
        return [lastThreeMonth, lastTwoMonth, lastMonth, lastWeek, thisWeek, yesterday, today, dueToday, dueTomorrow, dueInNextTwoDays, nextMonth]
    
    }
    
    private struct TestDate {
        
        static let calendar = Calendar.current
        
        static var inLastThreeMonth: Date {
            return calendar.date(byAdding: .month, value: -3, to: Date())!
        }
        
        static var today: Date {
            return Date()
        }
        
        static var inLastTwoMonth: Date {
            return calendar.date(byAdding: .month, value: -2, to: Date())!
        }
        
        static var lastMonth: Date {
            return calendar.date(byAdding: .month, value: -1, to: Date())!
        }
        
        static var lastWeek: Date {
            return calendar.date(byAdding: .day, value: -7, to: Date())!
        }
        
        static var thisWeek: Date {
            return calendar.date(byAdding: .day, value: -2, to: Date())!
        }
        
        static var yesterday: Date {
            return calendar.date(byAdding: .day, value: -1, to: Date())!
        }
        
        static var tomorrow: Date {
            return calendar.date(byAdding: .day, value: 1, to: Date())!
        }
        
        static var inNextTwoDays: Date {
            return calendar.date(byAdding: .day, value: 2, to: Date())!
        }
        
        static var nextMonth: Date {
                   return calendar.date(byAdding: .month, value: 1, to: Date())!
        }
    }
}
