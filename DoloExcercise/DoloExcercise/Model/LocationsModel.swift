//
//  File.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/21/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationCell {
    let name: String
    let address: String
    let distance: String?
    var imageUrl: String?
    
    init(name: String, location: Location, currentLocation: CLLocation, imageUrl: String? = nil) {
        self.name = name
        
        let addressString = String.buildLocationString(location: location)
        self.address = addressString
        
        let lat = location.lat
        let long = location.lng
        let venueLocation = CLLocation(latitude: lat, longitude: long)        
        let clDistance = Int(venueLocation.distance(from: currentLocation))
        
        if clDistance > 999 {
            let kmDistance = clDistance / 1000
            self.distance = String(describing: kmDistance) + "km"
        } else {
            self.distance = String(describing: clDistance) + "m"
        }
        
        if let imageUrl = imageUrl{
            self.imageUrl = imageUrl
        }
    }
}
