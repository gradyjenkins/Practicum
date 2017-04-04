//
//  AddOrViewFriendTableViewController.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit
import Firebase

class AddOrViewFriendTableViewController: UITableViewController, UITextFieldDelegate {

    //current user ID
    let userID = FIRAuth.auth()?.currentUser?.uid
    var ref: FIRDatabaseReference!
    var friendName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendInfo", for: indexPath) as! FriendInfoTableViewCell

        // Configure the cell...
        cell.friendInfoLabel.text = "First Name:"
        cell.friendInfoTextField.text = "Name"
        cell.friendInfoTextField.tag = indexPath.row
        
        friendName = cell.friendInfoTextField.text!

        return cell
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation
    

    //Dismiss current view and display FriendsTableViewController
    @IBAction func backToFriends(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    /**
     Save friend button functionality that will add a friend to the current user's node
     
     @param 
 
     @return Will add friend to the user's friendslist
    */
    @IBAction func saveChangesButton(_ sender: UIBarButtonItem) {
        //Execute necessary code to update database
        ref = FIRDatabase.database().reference(fromURL: "https://currentlocationtracker-8e2c9.firebaseio.com/")
        let indexpathForEmail = IndexPath(row: 0, section: 0)
        let emailCell = tableView.cellForRow(at: indexpathForEmail)! as! FriendInfoTableViewCell
        
        if emailCell.friendInfoTextField.placeholder!.isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "all fields are required to be filled in", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            friendName = emailCell.friendInfoTextField.text!
//            print(friendName!)
        }
        
 
        print(friendName!)
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let friend = friendName else {
            return
       }
        
        let values = ["name": friend]
        
        
        let userRef = ref.child("users").child(uid).child("friends")
        userRef.childByAutoId().updateChildValues(values)
        
//        (values, withCompletionBlock: {
//            (err, ref) in
//            
//            if err != nil {
//                print(err)
//                return
//            }
//            print("Saved friend successfully")
//        })

        
        //Dismiss view - return to FriendsTableViewController
        dismiss(animated: true, completion: nil)
    }

}
