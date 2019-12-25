//
//  BoardDetailViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class BoardDetailViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    var titleView: BoardTextFieldTitleView?
    
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    @IBOutlet weak var columnCollectionView: UICollectionView!
    
    var statusCollectionController: BoardDetailStatusViewController?
    var columnCollectionController: BoardDetailColumnViewController?
    
    @IBOutlet weak var stackView: UIStackView!
    
    var statuses: List<Status>?
    var columns: List<Column>?
    
    // MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize title view
        titleView = .fromNib()
        navigationItem.titleView = titleView
        
        // Disable the create button when the view is loaded
        createButton.isEnabled = false
        
        initStatusCollectionView()
        
        initColumnCollectionView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        columnCollectionView.collectionViewLayout.invalidateLayout()
        statusCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Helper methods
    
    private func initStatusCollectionView() {
        
        // Make the collection view round
        statusCollectionView.layer.cornerRadius = 5.0
        statusCollectionView.clipsToBounds = true
        
        // Status Collection View
        statusCollectionController = BoardDetailStatusViewController()
        statusCollectionController?.statuses = statuses
        
        // Add data source and delegate
        statusCollectionView.delegate = statusCollectionController
        statusCollectionView.dataSource = statusCollectionController
        let layout = statusCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true

    }
    
    private func initColumnCollectionView() {
        // Make the collection view round
        columnCollectionView.layer.cornerRadius = 5.0
        columnCollectionView.clipsToBounds = true
        
        // Column Collection View
        columnCollectionController = BoardDetailColumnViewController()
        columnCollectionController?.columns = columns
        
        // Add data source and delegate
        columnCollectionView.delegate = columnCollectionController
        columnCollectionView.dataSource = columnCollectionController
        
    }
    
    // MARK: - IB Actions
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonPressed(_ sender: UIBarButtonItem) {
    }
}
