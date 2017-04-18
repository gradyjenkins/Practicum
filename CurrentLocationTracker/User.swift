//
//  User.swift
//  CurrentLocationTracker
//
//  Created by Grady Jenkins on 4/16/17.
//  Copyright © 2017 Ryan O'Rourke. All rights reserved.
//

import Foundation
class User: NSObject {
    var name: String?
    var phoneNumber: String?
    init(dictionary: [String:AnyObject]) {
        self.name = dictionary["name"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
    }
}
