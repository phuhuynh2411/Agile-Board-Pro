//
//  RowTableViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit

class ColumnTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var issueCollectionView: UICollectionView!
    @IBOutlet weak var assigneeCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var issueList: [Issue]?
    
    var columnIndexPath: IndexPath?
    
    // a initial frame of Issue Collection View
    var initialFrame: CGRect?
    
    // MARK: - Init Methods
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        // Add your code here
        
        
    }
    
    // MARK: - Supporting Methods
    func tableView(reloadDataAt indexPath: IndexPath, withIssues issueList: [Issue]) {
        
        columnIndexPath = indexPath
        self.issueList = issueList
        
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StoryTableViewCell
        
        cell.summaryLabel.text = issueList?[indexPath.row].summary
        
        return cell
    }
    
    // MARK: - Table Header
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "TO DO (3)"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        // Make the table header round
        //view.layer.cornerRadius = 5.0
        //view.layer.masksToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(gestureRecognizer:)))
        view.addGestureRecognizer(panGesture)
        
        // Store the initial point of the collection view
        if initialFrame == nil {
            initialFrame =  issueCollectionView.frame
        }

    }
    
    @objc func panAction(gestureRecognizer: UIPanGestureRecognizer) {
        
        guard gestureRecognizer.view != nil else {return}
        //let view = gestureRecognizer.view!
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            
            // Move the issue collection view up or down
            let center = issueCollectionView.center
            issueCollectionView.center = CGPoint(x: center.x, y: center.y + translation.y)
            
            // Issue Collection Frame
            let minY = issueCollectionView.frame.minY
            let minX = issueCollectionView.frame.minX
            let with = issueCollectionView.frame.width
            let height = issueCollectionView.frame.height
            
            // If issue collection's frame y is less than or equal to assign collection's frame y
            // Set issue collection y to assignee collection y
            if minY <= assigneeCollectionView.frame.minY {
                issueCollectionView.frame = CGRect(x: minX, y: assigneeCollectionView.frame.minY, width: with, height: height)
            }
            
            // If issue collection's frame y is greater than or equal to the its initial frame
            // Set its current y to its initial y
            if minY >= initialFrame!.minY {
                issueCollectionView.frame = initialFrame!
            }
                        
            gestureRecognizer.setTranslation(CGPoint.zero, in: issueCollectionView)
        }
    }
}
