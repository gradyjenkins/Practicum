//
//  LoginViewController.swift
//  CurrentLocationTracker
//
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
    
    
    @IBAction func goToCreateAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createAccountSegue", sender: self)

    }
    
    @IBAction func loginButton(_ sender: AnyObject)
    {
        guard let email = usernameTextField.text, let password = passwordTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {
            (user, error) in
            
            if error != nil {
                print("TESTING: \(error)")
                return
            }
        })
        
        //Add this to section after validation where login credentials are valid
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
//    func checkIfUserIsLoggedIn() {
//        if FIRAuth.auth()?.currentUser?.uid == nil {
//            performSelector(#selector(handleLogout), withObject: nil, afterDelay: 0)
//        } else {
//            FIRDatabase.database().reference().child("users")
//        }
//    }
//    
//    func handleLogout() {
//        do {
//            try FIRAuth.auth()?.signOut()
//        } catch let logoutError {
//            print(logoutError)
//        }
//    }
//    
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
