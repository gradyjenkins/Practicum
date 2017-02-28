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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendInfo", forIndexPath: indexPath) as! FriendInfoTableViewCell

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
    @IBAction func backToFriends(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    //Save Button Functionality
    @IBAction func saveChangesButton(sender: UIBarButtonItem) {
        //Execute necessary code to update database
        ref = FIRDatabase.database().referenceFromURL("https://currentlocationtracker-8e2c9.firebaseio.com/")
        let indexpathForEmail = NSIndexPath(forRow: 0, inSection: 0)
        let emailCell = tableView.cellForRowAtIndexPath(indexpathForEmail)! as! FriendInfoTableViewCell
        
        if emailCell.friendInfoTextField.placeholder!.isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "all fields are required to be filled in", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            friendName = emailCell.friendInfoTextField.text!
            print("Hopefully this works 1: " + friendName!)
        }
        
        
        
        
        
        
        print("Hopefully this works: " + friendName!)
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let friend = friendName else {
            return
       }
        
       let values = ["name": friend]

        self.ref.child("users").child(uid).child("friends").updateChildValues(values, withCompletionBlock: {
            (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            print("Saved friend successfully")
        })
        
        
        //Dismiss view - return to FriendsTableViewController
        dismissViewControllerAnimated(true, completion: nil)
    }

}
