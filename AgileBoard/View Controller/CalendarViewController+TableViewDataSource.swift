//
//  CalendarViewController+TableViewDataSource.swift
//  Agile Board
//
//  Created by Huynh Tan Phu on 2/20/20.
//  Copyright © 2020 Filesoft. All rights reserved.
//

import UIKit

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesForSelectedDates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseableTableViewCell) as! IssueCalendarTableViewCell
        cell.delegate = self
        
        guard let issue = issuesForSelectedDates?[indexPath.row] else { return cell }
        
        cell.idLabel.text = issue.issueID
        cell.titleLabel.text = issue.summary
        cell.statusLabel.text = issue.status?.name
        
        if let typeImageName = issue.type?.imageName {
            cell.typeImageView.image = UIImage(named: typeImageName)
        }
        
        if let priorityImagename = issue.priority?.imageName {
            cell.prioriyImageView.image = UIImage(named: priorityImagename)
        }
        
        if let statusColor = issue.status?.color?.hexColor {
            let color = UIColor(hexString: statusColor)
            cell.statusImageView.image = UIImage(color: color)
        }
        
        if let dueDate = issue.dueDate, calendar.isDate(dueDate, inSameDayAs: Date()){
            cell.dueLabel.text = "Due today"
        } else {
            cell.dueLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}
