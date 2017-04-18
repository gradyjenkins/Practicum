//
//  BeaconViewController.swift
//  CurrentLocationTracker
//
//  Created by Tejal Deshpande on 4/17/17.
//  Copyright © 2017 Ryan O'Rourke. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

class BeaconViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!

    @IBOutlet weak var beaconLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    
}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    
    func startScanning() {
        let uuid = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 1, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            var stringDistance = String(distance.rawValue)
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
               self.beaconLabel.text =  "Your friend is " + stringDistance + " meters away!"
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                print(stringDistance)
                self.beaconLabel.text =  "Your friend is " + stringDistance + " meters away!"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.beaconLabel.text = "Your friend is " + stringDistance + " meters away!"

                print(stringDistance)
                //print(distance.rawValue)
            case .immediate:
                self.view.backgroundColor = UIColor.red
                //print(distance.rawValue)
                print(stringDistance)
                self.beaconLabel.text = "Your friend is " + stringDistance + " meters away!"

            }
        }
    }
    

} //end class

