//
//  MoreViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 11/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import SafariServices

class MoreViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.section == 0 else {
            return
        }
        
        switch indexPath.row {
        case 0:
            self.presentViewController(self.createSVC("https://2016.fossasia.org/"), animated: true, completion: nil)
            break
        case 1:
            self.presentViewController(self.createSVC("https://twitter.com/fossasia"), animated: true, completion: nil)
            break
        case 3:
            self.presentViewController(self.createSVC("http://groups.google.com/group/fossasia"), animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func createSVC(urlString: String) -> SFSafariViewController {
        return SFSafariViewController(URL: NSURL(string: urlString)!)
    }
}
