//
//  DataModel.swift
//  Past_Locations
//
//  Created by Alex Hoff on 7/20/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation

class VisistedPoint {
    
    var latitude: String
    var longitude: String
    
    init(lat: String, long: String) {
        self.latitude = lat
        self.longitude = long
    }
}
