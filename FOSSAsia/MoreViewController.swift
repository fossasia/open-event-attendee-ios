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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).section == 0 else {
            return
        }
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            self.present(self.createSVC("https://2016.fossasia.org/"), animated: true, completion: nil)
            break
        case 1:
            self.present(self.createSVC("https://twitter.com/fossasia"), animated: true, completion: nil)
            break
        case 2:
            let alertController = UIAlertController(title: "Open App Store?", message: "Tapping OK will temporarily exit this application and open the app's page on the App Store", preferredStyle: .alert)
            let openAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                let itunesLink = "https://itunes.apple.com/us/app/fossasia/id1089164461?ls=1&mt=8"
                UIApplication.shared.openURL(URL(string: itunesLink)!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                // do nothing
            })
            alertController.addAction(openAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: { () -> Void in
                
            })

            break
        case 3:
            self.present(self.createSVC("http://groups.google.com/group/fossasia"), animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    func createSVC(_ urlString: String) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: urlString)!)
    }
}
