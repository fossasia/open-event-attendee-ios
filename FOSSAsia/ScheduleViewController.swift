//
//  FirstViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ScheduleViewController: EventsBaseViewController, SwipeToFavoriteCellPresentable, TableViewRefreshable {
    var refreshControl = UIRefreshControl()
    
    // Constants for Storyboard/VC
    struct StoryboardConstants {
        static let storyboardName = "ScheduleVC"
        static let viewControllerId = String(ScheduleViewController)
    }
    
    lazy var filteredEvents: [EventViewModel] = self.allEvents
    var filterString: String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty {
                filteredEvents = self.allEvents
            } else {
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                filteredEvents = allEvents.filter( {filterPredicate.evaluateWithObject($0.eventName) } )
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refreshData:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    class func scheduleViewControllerFor(schedule: ScheduleViewModel) -> ScheduleViewController {
        let storyboard = UIStoryboard(name: ScheduleViewController.StoryboardConstants.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(ScheduleViewController.StoryboardConstants.viewControllerId) as! ScheduleViewController
        viewController.viewModel = schedule
        
        return viewController
    }
    
    func refreshData(sender: AnyObject) {
        viewModel?.refresh()
    }
}

extension ScheduleViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard searchController.active else {
            return
        }
        filterString = searchController.searchBar.text
    }
}

extension ScheduleViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EventsBaseViewController.kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        let eventViewModel = allEvents[indexPath.row]
        cell.configure(withPresenter: eventViewModel)
        cell.delegate = self
        
        return cell
    }
}


// MARK:- SwipeToFavoriteCellPresentable Conformance
extension ScheduleViewController {
    func favoriteEvent(indexPath: NSIndexPath)  {
        weak var me = self
        let eventViewModel = me!.eventViewModelForIndexPath(indexPath)
        eventViewModel.favoriteEvent { (eventViewModel, error) -> Void in
            if error == nil {
                self.tableView.reloadData()
            }
        }
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        swipeSettings.transition = .Border
        expansionSettings.buttonIndex = 0
        
        weak var me = self
        let eventViewModel = me!.eventViewModelForIndexPath(me!.tableView.indexPathForCell(cell)!)
        
        if direction == .LeftToRight {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2
            
            
            let faveButton = MGSwipeButton(title: "", icon: (eventViewModel.isFavorite ? UIImage(named: "cell_favorite_selected") : UIImage(named: "cell_favorite")), backgroundColor: Colors.favoriteOrangeColor!) { (sender: MGSwipeTableCell!) -> Bool in
                if let sessionCell = sender as? EventCell {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        if (eventViewModel.isFavorite) {
                            sessionCell.favoriteImage.transform = CGAffineTransformMakeScale(0.1, 0.1)
                            sessionCell.favoriteImage.alpha = 0.0
                        } else {
                            sessionCell.favoriteImage.transform = CGAffineTransformIdentity
                            sessionCell.favoriteImage.alpha = 1.0
                        }
                        }, completion: { (done) -> Void in
                            if done {
                                self.favoriteEvent(me!.tableView.indexPathForCell(cell)!)
                            }
                    })
                }
                return true
            }
            
            faveButton.setPadding(CGFloat(20))
            cell.leftButtons = [faveButton]
            
            return [faveButton]
        }
        return nil
    }
}