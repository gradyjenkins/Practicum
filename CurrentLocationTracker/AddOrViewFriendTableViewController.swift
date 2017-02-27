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
        cell.friendInfoTextField.text = "Bob"
        cell.friendInfoTextField.tag = indexPath.row

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
        let indexPath = self.tableView!.indexPathForSelectedRow()!
        let selectedCell = self.tableView!.cellForRowAtIndexPath(selectedIndexPath!) as! FriendInfoTableViewCell
        
        self.friendString = selectedCell.
        
        ref = FIRDatabase.database().referenceFromURL("https://currentlocationtracker-8e2c9.firebaseio.com/")
        
        guard let friend = friendNameField.text, uid = FIRAuth.auth()?.currentUser?.uid
            else {
                return
        }
        let friendName = friend as NSString
        
        
        let values = ["name": friendName]
        self.ref.child("users").child(uid).child("friends").updateChildValues(values)
        
        
        //Dismiss view - return to FriendsTableViewController
        dismissViewControllerAnimated(true, completion: nil)
    }

}
