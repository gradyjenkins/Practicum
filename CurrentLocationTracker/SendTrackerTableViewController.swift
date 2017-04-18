//
//  SendTrackerTableViewController.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit
import Firebase

class SendTrackerTableViewController: UITableViewController {
    
    var friends = [Friend]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        
    }

        

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    //Function to set up each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sendToFriend", for: indexPath) as! SendToFriendTableViewCell

        let friend = friends[indexPath.row]
        
        //set cell label to friends names
        cell.friendNameLabel.text = friend.name
        //switch handler
        cell.sendSwitch.setOn(false, animated: true)
        
        //add code to handle when switch is on to update database - will be needed on completion of sending tracker
        
        return cell
    }
    
    func fetchUser() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("friends").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let friend = Friend()
                friend.setValuesForKeys(dictionary)
                self.friends.append(friend)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //print(friend.name)
            }
            
            
        }, withCancel: nil)
    }

    
    
    
    // MARK: - Navigation
    
    //Functionality for when Next button is pressed
    @IBAction func nextButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "selectDestinationSegue", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "selectDestinationSegue" {
            let destination = segue.destination as! UINavigationController
            destination.viewControllers[0] as! SelectDestinationViewController
        }
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    

}
