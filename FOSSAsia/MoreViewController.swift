//
//  MoreViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 11/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import SafariServices

private struct DefaultURLs {
    static let fossasia2018 = "https://2018.fossasia.org/"
    static let fossaisaTwitter = "https://twitter.com/fossasia"
    static let fossasiaItune = "https://itunes.apple.com/us/app/fossasia/id1089164461?ls=1&mt=8"
    static let fossasiaGoogleGroups = "http://groups.google.com/group/fossasia"
}

class MoreViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).section == 0 else {
            return
        }

        switch (indexPath as NSIndexPath).row {
        case 0:
            self.present(self.createSVC(DefaultURLs.fossasia2018), animated: true, completion: nil)
            break
        case 1:
            self.present(self.createSVC(DefaultURLs.fossaisaTwitter), animated: true, completion: nil)
            break
        case 2:
            let alertController = UIAlertController(title: Constants.appStoreAlertTitle, message: Constants.appStoreAlertMessage, preferredStyle: .alert)
            let openAction = UIAlertAction(title: Constants.okTitle, style: .default, handler: { (action) -> Void in
                let itunesLink = DefaultURLs.fossasiaItune
                if let url = URL(string: itunesLink) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            let cancelAction = UIAlertAction(title: Constants.cancelTitle, style: .cancel, handler: { (action) -> Void in
                // do nothing
            })
            alertController.addAction(openAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: { () -> Void in

            })

            break
        case 3:
            self.present(self.createSVC(DefaultURLs.fossasiaGoogleGroups), animated: true, completion: nil)
            break
        default:
            break
        }
    }

    func createSVC(_ urlString: String) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: urlString)!)
    }
}
