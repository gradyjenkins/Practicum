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
    let mapRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        currentlyTrackingMap.mapType = .standard
        currentlyTrackingMap.delegate = self
        currentlyTrackingMap.userTrackingMode = .follow
    }

    // MARK: - Navigation

    @IBAction func showTrackingInfo(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "trackingInfoSegue", sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "trackingInfoSegue" {
            let destination = segue.destination as! UINavigationController
            destination.viewControllers[0] as! TrackingInfoTableViewController
        }
    }

    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
