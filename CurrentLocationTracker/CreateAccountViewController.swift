//
//  CreateAccountViewController.swift
//  CurrentLocationTracker
//
//  Created by Grady Jenkins on 12/20/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * FIXME Error handling in creating account
     * -Existing account, invalid email, etc.
     *
     */
    @IBAction func CreateAccount(_ sender: AnyObject)
    {
        guard let email = emailField.text, let phoneNumber = phoneNumField.text, let password = passwordField.text else{
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user: FIRUser?, error) in
            
            if error != nil {
                
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        let alert = UIAlertController(title: "Email not found", message: "Please enter a valid email", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Error", style: .default) { _ in })
                        self.present(alert, animated: true) {}
                    default:
                        let alert = UIAlertController(title: "Create user error", message: "Create user error: \(error)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Error", style: .default) { _ in })
                        self.present(alert, animated: true) {}
                    }
                    
                    
                }
                return
            }
            //Successfully authenticated user
            
            guard let uid = user?.uid else {
                return
            }
            
            print(uid)
            
            let ref = FIRDatabase.database().reference(fromURL: "https://currentlocationtracker-8e2c9.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["email":email, "phone number":phoneNumber]
            usersReference.updateChildValues(values, withCompletionBlock: {
                (err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                print("Saved user successfully")
                self.dismiss(animated: true, completion: nil)
            })
        })
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
