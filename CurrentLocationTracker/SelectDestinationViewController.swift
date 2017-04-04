//
//  SelectDestinationViewController.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit

class SelectDestinationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var startingPointField: UITextField!
    @IBOutlet weak var endingPointField: UITextField!
    
    @IBOutlet weak var destinationPicker: UIPickerView!
    
    var start = ["Wilson Hall", "Howard Hall", "Bey Hall", "Dorms", "Library"]
    var end = ["Wilson Hall", "Howard Hall", "Bey Hall", "Dorms", "Dining Hall"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        destinationPicker.isHidden = true
        
        destinationPicker.delegate = self
        destinationPicker.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: (#selector(SelectDestinationViewController.updatePicker)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
    }
    
    func updatePicker() {
        destinationPicker.isHidden = false
        self.destinationPicker.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returns the number of columns to display
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //When user selects starting point
        if startingPointField.isFirstResponder {
            return start[row]
        }
            //When user selects end destination text field
        else if endingPointField.isFirstResponder {
            return end[row]
        }
        
        //If neither is first responder, picker data is nil
        return nil
    }
    
    //returns the number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        //When user selects starting point
        if startingPointField.isFirstResponder {
            return start.count
        }
        //When user selects end destination text field
        else if endingPointField.isFirstResponder {
            return end.count
        }

        //If neither is first responder, count is nil
        return 0
    }
    
    //selected picker row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //When user selects starting point
        if startingPointField.isFirstResponder {
            let selectedDestination = start[row]
            startingPointField.text = selectedDestination
        }
            //When user selects end destination text field
        else if endingPointField.isFirstResponder {
            let selectedDestination = end[row]
            endingPointField.text = selectedDestination
        }
    }
    
    @IBAction func execTrackRequest(_ sender: UIBarButtonItem) {
        //Add Code Here to handled execution of tracking request by user
        
        //Either setup unwind segue to return to initial setup view or pop back to that view
    }
    
    //Handles the cancel button functionality
    @IBAction func cancelTracking(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
