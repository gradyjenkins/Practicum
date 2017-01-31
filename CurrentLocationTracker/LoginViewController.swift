//
//  LoginViewController.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
//    @IBAction func createAccountButton(sender: UIButton)
//    {
//        self.performSegueWithIdentifier("createAccountSegue", sender: self)
//    }
    
    
    @IBAction func goToCreateAccount(sender: UIButton) {
        self.performSegueWithIdentifier("createAccountSegue", sender: self)

    }
    
    /*
     * Login Button Action 
     *   - When pressed validate username and password
     *   - If valid segue to tab bar controller
     *   - Else alert user and dont perform segue
     */
    @IBAction func loginButton(sender: AnyObject)
    {
        //Add login validation code here
        if self.usernameTextField.text == "" || self.passwordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Error!", message: "Enter a valid email and password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signInWithEmail(self.usernameTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
                
                if error == nil
                {
                    self.usernameTextField.text = user!.email
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
                }
                else
                {
                    let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
            })
        }
        //Add this to section after validation where login credentials are valid
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        if segue.identifier == "loginSegue" {
//            segue.destinationViewController as! UITabBarController
//        }
//    }

}
