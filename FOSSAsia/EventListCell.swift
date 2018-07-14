//
//  EventListCell.swift
//  FOSSAsia
//
//  Created by Apple on 24/07/18.
//  Copyright © 2018 FossAsia. All rights reserved.
//

import UIKit

class EventListCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventMonth: UILabel!
     @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventName: UILabel!
     @IBOutlet weak var locationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
