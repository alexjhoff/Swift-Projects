//
//  DataStore.swift
//  Past_Locations
//
//  Created by Alex Hoff on 7/20/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation

struct StorageKeys {
    
    static let storedLat = "storedLat"
    static let storedLong = "storedLong"
}

class DataStore {
    
    func getDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func StoreDataPoint(latitude: String, longitude: String) {
        let def = getDefaults()
        
        def.setValue(latitude, forKey: StorageKeys.storedLat)
        def.setValue(longitude, forKey: StorageKeys.storedLong)
        def.synchronize()
        
        print(latitude + " : " + longitude)
    }
    
    func getLastLocation() -> VisistedPoint? {
        let defaults = getDefaults()
        
        if let lat = defaults.string(forKey: StorageKeys.storedLat){
            if let long = defaults.string(forKey: StorageKeys.storedLong){
                return VisistedPoint(lat: lat, long: long)
            }
        }
        return nil
    }
}
