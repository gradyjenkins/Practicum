//
//  Sensor.swift
//  CurrentLocationTracker
//
//  Created by Grady Jenkins on 4/14/17.
//  Copyright © 2017 Ryan O'Rourke. All rights reserved.
//

import Foundation
import MapKit

class Sensor: NSObject, MKAnnotation
{
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D){
        self.name = name
        self.coordinate = coordinate
        
        super.init()
    }
}
