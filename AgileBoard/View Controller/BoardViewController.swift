//
//  ViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 11/12/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class BoardViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pageControl: IssuePageControlView!
    
    @IBOutlet weak var collectionView: IssueCollectionView!
    
    // Project
    var project: Project?
        
    override func viewDidLoad() {
        
        // Set the number of pages for the page control
        let columns = project?.boards.first?.columns
        self.pageControl.numberOfPages = columns?.count ?? 0
        
        // Remove navigation border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.controller?.project = project
    }
    
    override func viewDidLayoutSubviews() {
        
        // Adjust collection view cell
        collectionView.adjustCellSize()
        
        // Pass the page control through the collection view
        collectionView.controller?.pageControl = pageControl
        
        // Show or Hide the page control
        showHidePageControl()
        
        // Adjust Paging based the portrait and landscape mode
        adjustPaging()
        
        collectionView.reloadData()
    }
    
    func showHidePageControl() {
        
        // Portrait mode
        if UIDevice.current.orientation.isPortrait {
            pageControl.setVisible(state: true, with: 37)
        }
        // Landscape mode
        else {
            pageControl.setVisible(state: false, with: 10)
        }
    }
    
    /**
        Enables the paging in portrait mode and disables the paging in landscape mode
     */
    func adjustPaging() {
        
        if UIDevice.current.orientation.isPortrait {
            collectionView.isPagingEnabled = true
        }
        else {
            collectionView.isPagingEnabled = false
        }
    }

}

// MARK: - Orientation Changes

extension BoardViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print("View will transition")
                
        // Adjusts the paging of the collection view
        adjustPaging()
        
        // Show or hide the page control
        showHidePageControl()

        // Reload the collection data when users change the orientation
        // Portait/Landscape mode
        // collectionView.reloadData()
        
    }
    
}
