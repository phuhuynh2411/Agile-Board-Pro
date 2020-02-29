//
//  BoardDetailColumnViewController.swift
//  AgileBoard
//
//  Created by Huynh Tan Phu on 12/24/19.
//  Copyright © 2019 Filesoft. All rights reserved.
//

import UIKit
import RealmSwift

class BoardDetailColumnViewController: NSObject {

    var columns: List<Column>?
    var pageControl: UIPageControl?
    var collectionView: UICollectionView?
    
}

// MARK: - UICollection View Datasource

extension BoardDetailColumnViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let count = columns?.count ?? 0
        if count == 0 {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
        // Update the total page number
        pageControl?.numberOfPages = count + 1
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColumnCell", for: indexPath) as! BColumnColumnCollectionViewCell
        
        // Make the cell round
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        // Make the placeholder view round
        cell.placeholderView.layer.cornerRadius = 10.0
        cell.placeholderView.clipsToBounds = true
        
        let column = columns?[indexPath.row]
        
        if let status = column?.status, let hexColor = status.color?.hexColor {
            let uiColor = UIColor(hexString: hexColor)
            cell.placeholderView.backgroundColor = uiColor
            cell.nameLabel.text = status.name
            cell.nameLabel.textColor = UIColor().textColor(bgColor: uiColor)
        }
        
        // Update column number
        cell.numberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    // MARK: - View for collection header and footer
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var cellIdentifier = ""
        var viewType = ""
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            cellIdentifier = "FooterCell"
            viewType = UICollectionView.elementKindSectionFooter
            break
        default:
            print("Undefine view")
        }
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: viewType, withReuseIdentifier: cellIdentifier, for: indexPath) as! BColumnCollectionReusableView
        
        var number = columns?.count ?? 1
        number = number == 1 ? 1 : number + 1
        
        // cell.titleLabel.text = "COLUMN \(number)"
        cell.placeholderBackground.layer.cornerRadius = 10.0
        cell.placeholderBackground.clipsToBounds = true
        
        // Make the cell round
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        // Adjusts the footer's size to be equal the item size
        // let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // cell.frame.size = layout.itemSize
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       updatePageControl()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        updatePageControl()
    }
    
    private func updatePageControl() {
        // Update the total page numbers
        let count = (columns?.count ?? 1) + 1
        
        pageControl?.numberOfPages = count
    }
    
    
}

// MARK: - UICollection View Delegate

extension BoardDetailColumnViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return sizeForItem(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
                
        return sizeForItem(collectionView)
    }
    
    private func sizeForItem(_ collectionView: UICollectionView) ->CGSize {
        
        // Landscape mode
        let width = UIDevice.current.orientation.isLandscape ? collectionView.frame.width/2 - 5
            : collectionView.frame.width
           
        let insetTopBottom = collectionView.contentInset.top + collectionView.contentInset.bottom
        let height = collectionView.frame.height - insetTopBottom
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("move item")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape else { return }
        
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
    }
    
    private func scrollToLeft(_ scrollView: UIScrollView)-> Bool {
        return scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 ? true : false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // Only perform the following lines in portrait mode
        guard !UIDevice.current.orientation.isLandscape, let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout,
        let columns = columns else { return }
    
        let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
        var pageNumber = currentPageNumber()
        
        // If user scrolls the view to the left, decreases the page number;
        // otherwise, increases the page number
        pageNumber = self.scrollToLeft(scrollView) ? pageNumber - 1 : pageNumber + 1
        // If page number is less than 0, sets it to 0
        pageNumber = pageNumber < 0 ? 0 : pageNumber
        // If page number is greater than a number of columns, sets it to the number of columns
        pageNumber = pageNumber > columns.count ? columns.count : pageNumber
        
        let newX = CGFloat(pageNumber) * cellWidth
        
        let rect = CGRect(x: newX, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.scrollRectToVisible(rect, animated: true)
    
        // Update the page number
        pageControl?.currentPage = pageNumber
        
    }
    
    private func currentPageNumber()->Int {
        guard let collectionView = collectionView else { return 0 }
        
        let pageWidth = collectionView.frame.size.width
        let pageNumber: Int = Int(floor((collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        return pageNumber
    }
    
    
}

// MARK: - UICollectionViewDragDelegate

extension BoardDetailColumnViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let itemProvider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let column = columns?[indexPath.row]
        dragItem.localObject = (column: column, collectionView: collectionView, indexPath: indexPath)
        session.localContext = column

        return [dragItem]

    }
    
    
}

// MARK: - UICollectionViewDropDelegate

extension BoardDetailColumnViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if destinationIndexPath == nil {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertIntoDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let item = coordinator.items.first else { return }
        
        // Source index path will be nil, if users drags item from another collection view into this collection view
        // You are re-ordering the items inside the collection view
        if let srcIndexPath = item.sourceIndexPath, let desIndexPath = coordinator.destinationIndexPath,
            let (column, _, _) = item.dragItem.localObject as? (Column, UICollectionView, IndexPath){
            
            // User are modifying an existing board
            if let _ = columns?.realm {
                columns?.write(code: {
                    columns?.remove(at: srcIndexPath.row)
                    columns?.insert(column, at: desIndexPath.row)
                }, completion: nil)
            }
            else {
                columns?.remove(at: srcIndexPath.row)
                columns?.insert(column, at: desIndexPath.row)
            }
            
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [srcIndexPath])
                collectionView.insertItems(at: [desIndexPath])
            }, completion: nil)

            coordinator.drop(item.dragItem, toItemAt: desIndexPath)
            collectionView.reloadVisibleItems()
            
            // Re-update the page number
            pageControl?.currentPage = currentPageNumber()
            
        }
        // Drag and drop an item from another collection view into this collection view
        else if let (status, srcCollectionView, srcIndexPath) = item.dragItem.localObject as? (Status, UICollectionView, IndexPath) {
            let column = Column()
            column.status = status
            // Get destination index path
            // Destination index path will be nil, if user drags item into collection view's footer
            if let desIndexPath = coordinator.destinationIndexPath {
                // The columns array is in realm
                // User is editing the board
                if let _ = columns?.realm {
                    columns?.insert(column, at: desIndexPath.row, completion: nil)
                }
                // User is adding a a new board.
                else {
                    columns?.insert(column, at: desIndexPath.row)
                }
                
                // Update collection view
                collectionView.insertItems(at: [desIndexPath])
                coordinator.drop(item.dragItem, toItemAt: desIndexPath)
                
                collectionView.reloadVisibleItems()
                
            } else {
                let lastIndexPath = IndexPath(row: columns?.count ?? 0, section: 0)
                // User is modifying an existing board
                if let _ = columns?.realm {
                    columns?.append(column, completion: nil)
                }
                // User is adding a new board
                else {
                    columns?.append(column)
                }
                collectionView.insertItems(at: [lastIndexPath])
            }
            
            // Remove the status at the source collection view
            if let datasource = srcCollectionView.dataSource as? BoardDetailStatusViewController,
                let srcStatuses = datasource.statuses{
                if let _ = srcStatuses.realm {
                    srcStatuses.remove(at: srcIndexPath.row, completion: nil)
                }
                else {
                    srcStatuses.remove(at: srcIndexPath.row)
                }
                srcCollectionView.deleteItems(at: [srcIndexPath])
                // Reload collection view's header
                srcCollectionView.reloadHeader()
            }
        }
    }
    
}
