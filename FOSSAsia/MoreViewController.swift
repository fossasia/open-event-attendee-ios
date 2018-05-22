//
//  MoreViewController.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 11/2/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

private struct DefaultURLs {
    static let fossasia2018 = "https://2018.fossasia.org/"
    static let fossaisaTwitter = "https://twitter.com/fossasia"
    static let fossasiaItune = "https://itunes.apple.com/us/app/fossasia/id1089164461?ls=1&mt=8"
    static let fossasiaGoogleGroups = "http://groups.google.com/group/fossasia"
    static let fossasiaFacebook = "https://www.facebook.com/fossasia/share"
}

class MoreViewController: UITableViewController, MFMailComposeViewControllerDelegate , MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            let myalert = UIAlertController(title: "Cancelled", message: "Message Cancelled", preferredStyle: UIAlertControllerStyle.alert)
            
            myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            })
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            let myalert = UIAlertController(title: "Failed", message: "Message Failed", preferredStyle: UIAlertControllerStyle.alert)
            
            myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            })
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            let myalert = UIAlertController(title: "Sent", message: "Message Sent", preferredStyle: UIAlertControllerStyle.alert)
            
            myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            })
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    func configureMailComposeViewController(recipient: String,
                                            subject: String,
                                            message: String) ->MFMailComposeViewController {
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([recipient])
        mail.setSubject(subject)
        mail.setMessageBody(message, isHTML: true)
        
        return mail
    }
    
    func showSendMailErrorAlert() {
        let sendMailAlert = UIAlertController(title: "Couldn't Send Mail",
                                              message: "Your Device Couldn't Send Mail"
,
                                              preferredStyle: UIAlertControllerStyle.alert)
        
        sendMailAlert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        })
        self.present(sendMailAlert, animated: true)
    }
    
    private func mailComposeController(_ controller:MFMailComposeViewController,
                               didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result {
        case .cancelled:
            let myalert = UIAlertController(title: "Cancelled", message: "Mail Cancelled", preferredStyle: UIAlertControllerStyle.alert)
            
            myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            })
            self.present(myalert, animated: true)
        case .saved:
            let myalert = UIAlertController(title: "Saved", message: "Mail Saved", preferredStyle: UIAlertControllerStyle.alert)
            
            myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            })
            self.present(myalert, animated: true)
        case .sent:
            let myalert = UIAlertController(title: "Sent", message: "Mail Sent", preferredStyle: UIAlertControllerStyle.alert)
            
            myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            })
            self.present(myalert, animated: true)
            
        case .failed:
            print("Mail sent failure")
             default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

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
        case 4:
            let myActionSheet = UIAlertController(title: "Tell A Friend", message: "Whom you want to tell?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            // email action button
            let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.default) { (action) in
                let mailVc = self.configureMailComposeViewController(recipient: "", subject: "Check out the Open Event iOS!",
                                                                           message: "I am using the Open Event iOS , for browsing information about the event visit https://fossasia.org/ ")
                            if MFMailComposeViewController.canSendMail() {
                                self.present(mailVc, animated: true, completion: nil)
                            } else {
                                self.showSendMailErrorAlert()
                            }
            }
            
            // facebook action button
            let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default) { (action) in
                self.present(self.createSVC(DefaultURLs.fossasiaFacebook), animated: true, completion: nil)
            }
            
            // Message action button
            let messageAction = UIAlertAction(title: "Message", style: UIAlertActionStyle.default) { (action) in
                let messageVc = self.configureMessageComposeViewController(recipient: "", subject: "Check out the Open Event iOS!",
                                                                     body: "I am using the Open Event iOS , for browsing information about the event visit https://fossasia.org/ ")
                if MFMessageComposeViewController.canSendText() {
                    self.present(messageVc, animated: true, completion: nil)
                    
                }
            }
            
            // cancel action button
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            }
            
            // add action buttons to action sheet
            myActionSheet.addAction(emailAction)
            myActionSheet.addAction(facebookAction)
            myActionSheet.addAction(messageAction)
            myActionSheet.addAction(cancelAction)
            
            // present the action sheet
            self.present(myActionSheet, animated: true, completion: nil)
        break
        default:
            break
        }
    }

    func createSVC(_ urlString: String) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: urlString)!)
    }
    func configureMessageComposeViewController(recipient: String,
                                               subject: String,
                                               body: String) ->MFMessageComposeViewController {
        let message = MFMessageComposeViewController()
        message.messageComposeDelegate = self
        message.recipients = [recipient]
        message.subject = subject
        message.body = body
        return message
    
    }
}
