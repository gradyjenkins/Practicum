//
//  FriendInfoTableViewCell.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//
//  SELECTED FRIEND CELL



import UIKit
import Firebase

class FriendInfoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var friendInfoLabel: UILabel!
    
    @IBOutlet weak var friendInfoTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
