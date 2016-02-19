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

class FavoritesScheduleViewController: EventsBaseViewController, SwipeToFavoriteCellPresentable {
    struct StoryboardConstants {
        static let storyboardName = "Sessions"
        static let viewControllerId = String(FavoritesScheduleViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    class func scheduleViewControllerFor(schedule: ScheduleViewModel) -> FavoritesScheduleViewController {
        let storyboard = UIStoryboard(name: FavoritesScheduleViewController.StoryboardConstants.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(FavoritesScheduleViewController.StoryboardConstants.viewControllerId) as! FavoritesScheduleViewController
        viewController.viewModel = schedule
        
        return viewController
    }
}

extension FavoritesScheduleViewController: DZNEmptyDataSetSource {
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

// MARK:- UITableViewDelegate Conformance
extension FavoritesScheduleViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EventsBaseViewController.kEventCellReuseIdentifier, forIndexPath: indexPath) as! EventCell
        let eventViewModel = allEvents[indexPath.row]
        cell.configure(withPresenter: eventViewModel)
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedEventViewModel: EventViewModel
        selectedEventViewModel = self.allEvents[indexPath.row]
        
        let eventViewController = EventViewController.eventViewControllerForEvent(selectedEventViewModel)
        
        navigationController?.pushViewController(eventViewController, animated: true)
    }

}

// MARK:- SwipeToFavoriteCellPresentable Conformance
extension FavoritesScheduleViewController {
    func favoriteEvent(indexPath: NSIndexPath)  {
        let eventViewModel = self.eventViewModelForIndexPath(indexPath)
        eventViewModel.favoriteEvent { (viewModel, error) -> Void in
            if error == nil {
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
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
                                self.favoriteEvent(me!.tableView.indexPathForCell(sender)!)
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