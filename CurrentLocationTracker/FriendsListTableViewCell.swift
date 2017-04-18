//
//  FriendsListTableViewCell.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit
import Firebase

class FriendsListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var eachFriendName: UILabel!
    
    @IBOutlet weak var eachFriendNumber: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
