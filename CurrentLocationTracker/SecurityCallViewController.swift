//
//  SecurityCallViewController.swift
//  CurrentLocationTracker
//
//  Created by Grady Jenkins on 4/3/17.
//  Copyright © 2017 Ryan O'Rourke. All rights reserved.
//

import UIKit

class SecurityCallViewController: UIViewController {

    @IBOutlet weak var Call: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Call method
     -Will call Monmouth University Police Department
    */
    @IBAction func CallSecurity(_ sender: AnyObject)
    {
        var url:URL = URL(string: "tel://7326169129")!
        UIApplication.shared.openURL(url)
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
