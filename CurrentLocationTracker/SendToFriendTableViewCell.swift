//
//  SendToFriendTableViewCell.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit

class SendToFriendTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Handles the value for each friend name label
    @IBOutlet weak var friendNameLabel: UILabel!
    //Handles the values for each friend switch
    @IBOutlet weak var sendSwitch: UISwitch!
    
    @IBAction func statusChanged(_ sender: UISwitch) {
        var switchBool = sendSwitch.isOn
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
