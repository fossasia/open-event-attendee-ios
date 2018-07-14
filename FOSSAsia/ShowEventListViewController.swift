//
//  ShowEventListViewController.swift
//  FOSSAsia
//
//  Created by Apple on 14/07/18.
//  Copyright © 2018 FossAsia. All rights reserved.
//

import UIKit
import Material
import Alamofire
import AlamofireImage
import SwiftyJSON
import Toast_Swift

class ShowEventListViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var LocationTextField: TextField!


    @IBOutlet weak var tableView: UITableView!
    let loadingView = UIView()

    let spinner = UIActivityIndicatorView()

    let loadingLabel = UILabel()
    let placeholderImage = UIImage(named: "placeholder")!

    var eventList = [Events]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationTextField()
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }

    func setLocationTextField() {
        LocationTextField.delegate = self
        LocationTextField.attributedPlaceholder = NSAttributedString(string: "Where?",
            attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        LocationTextField.dividerActiveColor = .white


    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setLoadingScreen()
        loadEventList()
        return true
    }

    func loadEventList() {
        if let locationSearch = LocationTextField.text {
            print(locationSearch)

            let parameters: Parameters = ["sort": "name", "filter": """
            [{"name":"location-name","op":"ilike","val":"%\(locationSearch)%"}]
            """]


            Alamofire.request(Constants.Url.eventListUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                switch(response.result) {

                case .success(_):
                    self.removeLoadingScreen()
                    let json = JSON(response.result.value as Any)
                    if let eventListArray = json["data"].array {
                        for events in eventListArray {
                            let locationName = events["attributes"]["location-name"].stringValue
                            let imageURL = events["attributes"]["original-image-url"].stringValue
                            let eventName = events["attributes"]["name"].stringValue
                            let dateIsoFormat = events["attributes"]["starts-at"].stringValue
                            if let standardDateFormat = dateIsoFormat.components(separatedBy: "T").first {
                                let dateOfEvent = self.convertDateFormatter(date: standardDateFormat)
                                let eventDetails = Events(locationName: locationName, imageUrl: imageURL, eventName: eventName, dateOfEvent: dateOfEvent)
                                print(eventDetails)
                                self.eventList.append(eventDetails)


                            } else {
                                print("nil")
                            }
                            self.tableView.reloadData()
                        }


                    } else {
                        self.view.makeToast(Constants.ResponseMessages.ServerError)

                    }


                    break

                case .failure(_):
                    self.view.makeToast(Constants.ResponseMessages.ServerError)
                    break
                }
            }
        } else {
            self.view.makeToast("Text Field is empty!!")
        }

    }

    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }


    func convertDateFormatter(date: String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd"

        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        }
        else {
            print("There was an error decoding the string")
        }
        return "Jun 14"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventListCell
        let event = eventList[indexPath.row]
        cell.eventName.text = event.eventName
        cell.locationName.text = event.locationName
        cell.eventMonth.text = String(event.dateOfEvent.prefix(3))
        cell.eventDate.text = String(event.dateOfEvent.suffix(2))
        let downloadURL = NSURL(string: event.imageUrl)!
        let filter = AspectScaledToFillSizeFilter(size: cell.eventImage.frame.size)
        cell.eventImage.af_setImage(withURL: downloadURL as URL, placeholderImage: placeholderImage,filter: filter)
        return cell
    }

    // Set the activity indicator into the main view
    func setLoadingScreen() {

        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        // Sets spinner
        spinner.activityIndicatorViewStyle = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        self.tableView.addSubview(loadingView)

    }

    // Remove the activity indicator from the main view
    func removeLoadingScreen() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true

    }

}
