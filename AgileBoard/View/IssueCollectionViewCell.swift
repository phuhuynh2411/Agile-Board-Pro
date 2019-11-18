//
//  IssueCollectionViewCell.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/15/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class IssueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var issueTableView: IssueTableView!
    @IBOutlet weak var cellHeaderView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var cellFooterView: UIView!
        
    var collectionView: UICollectionView?
        
    var issueTableViewController: IssueTableViewController?
    
    var tableViewHeight: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            contentView.leftAnchor.constraint(equalTo: leftAnchor),
//            contentView.rightAnchor.constraint(equalTo: rightAnchor),
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
        
        // Register custom cell for the issue table view
        let nibName = UINib(nibName: Identifier.IssueTableViewCell, bundle: .main)
        issueTableView.register(nibName, forCellReuseIdentifier: Identifier.IssueTableViewCell)
        
        // Initilize the issue table view controller
        issueTableViewController = IssueTableViewController(style: .plain)
        
        // Set data source and delegate to the table view
        issueTableView.dataSource = issueTableViewController
        issueTableView.delegate = issueTableViewController
        
        
        // Round the header and footer
        cellHeaderView.layer.cornerRadius = 5.0
        cellHeaderView.layer.masksToBounds = true
        
        cellFooterView.layer.cornerRadius = 5.0
        cellFooterView.layer.masksToBounds = true
    }    

//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        //width.constant = bounds.size.width
//        print("call this one")
//        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
//    }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        
//        if tableViewHeight == nil {
//            UIView.animate(withDuration: 0, animations: {
//                self.issueTableView.layoutIfNeeded()
//            }) { (complete) in
//                
//                var heightOfTableView: CGFloat = 0.0
//                // Get visible cells and sum up their heights
//                let cells = self.issueTableView.visibleCells
//                for cell in cells {
//                    heightOfTableView += cell.frame.height
//                }
//                
//                print("Returned visible cell's height \(heightOfTableView)")
//                self.tableViewHeight = heightOfTableView
//                
//                //self.collectionView?.collectionViewLayout.invalidateLayout()
//            }
//        }
//        else {
//            
//            // If the visible table cell's height is great than the screen height, use the screen height
//            // otherwise, use the table cell's height
//            layoutAttributes.size.height = tableViewHeight!
//            
//            print("Returned layout attribute")
//            return layoutAttributes
//        }
//        
//        return layoutAttributes
//       
//    }
    
}
