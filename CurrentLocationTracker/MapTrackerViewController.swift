//
//  MapTrackerViewController.swift
//  CurrentLocationTracker
//
//  Created by Ryan O'Rourke on 7/31/16.
//  Copyright © 2016 Ryan O'Rourke. All rights reserved.
//

import UIKit
import MapKit

class MapTrackerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var currentlyTrackingMap: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        currentlyTrackingMap.mapType = .Standard
        currentlyTrackingMap.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    @IBAction func showTrackingInfo(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("trackingInfoSegue", sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "trackingInfoSegue" {
            let destination = segue.destinationViewController as! UINavigationController
            destination.viewControllers[0] as! TrackingInfoTableViewController
        }
    }

    @IBAction func logoutButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
