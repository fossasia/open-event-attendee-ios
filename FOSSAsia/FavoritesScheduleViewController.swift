//
//  FavoritesScheduleViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 13/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class FavoritesScheduleViewController: EventsBaseViewController, SwipeToFavoriteCellPresentable {
    struct StoryboardConstants {
        static let storyboardName = "Sessions"
        static let viewControllerId = String(FavoritesScheduleViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func scheduleViewControllerFor(schedule: ScheduleViewModel) -> FavoritesScheduleViewController {
        let storyboard = UIStoryboard(name: FavoritesScheduleViewController.StoryboardConstants.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(FavoritesScheduleViewController.StoryboardConstants.viewControllerId) as! FavoritesScheduleViewController
        viewController.viewModel = schedule
        
        return viewController
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
}

// MARK:- SwipeToFavoriteCellPresentable Conformance
extension FavoritesScheduleViewController {
    func favoriteEvent(indexPath: NSIndexPath)  {
        let eventViewModel = self.eventViewModelForIndexPath(indexPath)
        self.viewModel?.favoriteEvent(eventViewModel.sessionId.value)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
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