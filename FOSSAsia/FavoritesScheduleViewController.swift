//
//  FavoritesScheduleViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 13/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import DZNEmptyDataSet

typealias FavoritesEmptyState = protocol<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

class FavoritesScheduleViewController: SessionsBaseViewController, SwipeToFavoriteCellPresentable, FavoritesEmptyState {
    var refreshControl = UIRefreshControl()
    
    struct StoryboardConstants {
        static let storyboardName = "ScheduleVC"
        static let viewControllerId = String(FavoritesScheduleViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    class func scheduleViewControllerFor(schedule: ScheduleViewModel) -> FavoritesScheduleViewController {
        let storyboard = UIStoryboard(name: FavoritesScheduleViewController.StoryboardConstants.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(FavoritesScheduleViewController.StoryboardConstants.viewControllerId) as! FavoritesScheduleViewController
        viewController.viewModel = schedule
        
        return viewController
    }
}

// MARK:- DZNEmptyDataSetSource Conformance
extension FavoritesScheduleViewController {
    internal func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Favorites Yet!"
        let attributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        return NSAttributedString.init(string: text, attributes: attributes)
    }
    
    internal func buttonImageForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        switch state {
        case UIControlState.Highlighted:
            return UIImage(named: "browse_events_btn_selected")
        default:
            return UIImage(named: "browse_events_btn")
        }
    }
}

// MARK:- DZNEmptyDataSetDelegate Conformance
extension FavoritesScheduleViewController {
    internal func emptyDataSet(scrollView: UIScrollView!, didTapButton button: UIButton!) {
        self.tabBarController?.selectedIndex = 0
    }
}

// MARK:- UITableViewDelegate Conformance
extension FavoritesScheduleViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SessionsBaseViewController.kSessionCellReuseIdentifier, forIndexPath: indexPath) as! SessionCell
        let sessionViewModel = allSessions[indexPath.row]
        cell.configure(withPresenter: sessionViewModel)
        cell.delegate = self
        
        return cell
    }
}

// MARK:- SwipeToFavoriteCellPresentable Conformance
extension FavoritesScheduleViewController {
    func favoriteSession(indexPath: NSIndexPath)  {
        let sessionViewModel = self.sessionViewModelForIndexPath(indexPath)
        sessionViewModel.favoriteSession { [weak self] (viewModel, error) -> Void in
            if error == nil {
                self?.viewModel?.refresh()
                self?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
                self?.tableView.reloadData() // refresh empty state layout
            }
        }
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        swipeSettings.transition = .Border
        expansionSettings.buttonIndex = 0
        
        weak var me = self
        let sessionViewModel = me!.sessionViewModelForIndexPath(me!.tableView.indexPathForCell(cell)!)
        
        if direction == .LeftToRight {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2
            
            
            let faveButton = MGSwipeButton(title: "", icon: (sessionViewModel.isFavorite ? UIImage(named: "cell_favorite_selected") : UIImage(named: "cell_favorite")), backgroundColor: Colors.favoriteOrangeColor!) { (sender: MGSwipeTableCell!) -> Bool in
                if let sessionCell = sender as? SessionCell {
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        if (sessionViewModel.isFavorite) {
                            sessionCell.favoriteImage.transform = CGAffineTransformMakeScale(0.1, 0.1)
                            sessionCell.favoriteImage.alpha = 0.0
                        } else {
                            sessionCell.favoriteImage.transform = CGAffineTransformIdentity
                            sessionCell.favoriteImage.alpha = 1.0
                        }
                        }, completion: { (done) -> Void in
                            if done {
                                self.favoriteSession(me!.tableView.indexPathForCell(sender)!)
                            }
                    })
                }
                return false
            }
            
            faveButton.setPadding(CGFloat(20))
            cell.leftButtons = [faveButton]
            
            return [faveButton]
        }
        return nil
    }
}