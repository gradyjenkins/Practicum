//
//  IndividualTrackingInfoTableViewCell.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit

class IndividualTrackingInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneNumberFIeld: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func sendNotification(_ sender: Any) {
        ServiceManager.sharedInstance.sendNotificationsToTags(payload: ["tag_value": [self.phoneNumberFIeld.text!], "message": "Tracking!", "tag_key": "PhoneNumber"], successBlock: { (message) in
            
            Utility.sharedInstance.logMessage(message: message ?? "Successfully sent notification to: \(self.phoneNumberFIeld.text!) with message: \(String(describing: "Tracking"))")
        
            }) { (failureMessage) in
                Utility.sharedInstance.logMessage(message: failureMessage ?? "Error sending notification to: Phone Number with message: \("Tracking")")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
