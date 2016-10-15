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

typealias FavoritesEmptyState = DZNEmptyDataSetDelegate & DZNEmptyDataSetSource

class FavoritesScheduleViewController: EventsBaseViewController, SwipeToFavoriteCellPresentable, FavoritesEmptyState {
    var refreshControl = UIRefreshControl()
    
    struct StoryboardConstants {
        static let storyboardName = "ScheduleVC"
        static let viewControllerId = String(describing: FavoritesScheduleViewController())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    class func scheduleViewControllerFor(_ schedule: ScheduleViewModel) -> FavoritesScheduleViewController {
        let storyboard = UIStoryboard(name: FavoritesScheduleViewController.StoryboardConstants.storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: FavoritesScheduleViewController.StoryboardConstants.viewControllerId) as! FavoritesScheduleViewController
        viewController.viewModel = schedule
        
        return viewController
    }
}

// MARK:- DZNEmptyDataSetSource Conformance
extension FavoritesScheduleViewController {
    internal func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let text = "No Favorites Yet!"
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0),
            NSForegroundColorAttributeName: UIColor.darkGray]
        
        return NSAttributedString.init(string: text, attributes: attributes)
    }
    
    @objc(buttonImageForEmptyDataSet:forState:) internal func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> UIImage? {
        switch state {
        case UIControlState.highlighted:
            return UIImage(named: "browse_events_btn_selected")
        default:
            return UIImage(named: "browse_events_btn")
        }
    }
}

// MARK:- DZNEmptyDataSetDelegate Conformance
extension FavoritesScheduleViewController {
    @objc(emptyDataSet:didTapButton:) internal func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
}

// MARK:- UITableViewDelegate Conformance
extension FavoritesScheduleViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsBaseViewController.kEventCellReuseIdentifier, for: indexPath) as! EventCell
        let eventViewModel = allEvents[(indexPath as NSIndexPath).row]
        cell.configure(withPresenter: eventViewModel)
        cell.delegate = self
        
        return cell
    }
}

// MARK:- SwipeToFavoriteCellPresentable Conformance
extension FavoritesScheduleViewController {
    func favoriteEvent(_ indexPath: IndexPath)  {
        let eventViewModel = self.eventViewModelForIndexPath(indexPath)
        eventViewModel.favoriteEvent { [weak self] (viewModel, error) -> Void in
            if error == nil {
                self?.viewModel?.refresh()
                self?.tableView.deleteRows(at: [indexPath], with: .left)
                self?.tableView.reloadData() // refresh empty state layout
            }
        }
    }
    
    @objc(swipeTableCell:swipeButtonsForDirection:swipeSettings:expansionSettings:) func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        swipeSettings.transition = .border
        expansionSettings.buttonIndex = 0
        
        weak var me = self
        let eventViewModel = me!.eventViewModelForIndexPath(me!.tableView.indexPath(for: cell)!)
        
        if direction == .leftToRight {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2
            
            
            let faveButton = MGSwipeButton(title: "", icon: (eventViewModel.isFavorite ? UIImage(named: "cell_favorite_selected") : UIImage(named: "cell_favorite")), backgroundColor: Colors.favoriteOrangeColor!) { (sender: MGSwipeTableCell!) -> Bool in
                if let sessionCell = sender as? EventCell {
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        if (eventViewModel.isFavorite) {
                            sessionCell.favoriteImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                            sessionCell.favoriteImage.alpha = 0.0
                        } else {
                            sessionCell.favoriteImage.transform = CGAffineTransform.identity
                            sessionCell.favoriteImage.alpha = 1.0
                        }
                        }, completion: { (done) -> Void in
                            if done {
                                self.favoriteEvent(me!.tableView.indexPath(for: sender)!)
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
