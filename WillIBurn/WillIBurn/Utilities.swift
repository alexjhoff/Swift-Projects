//
//  Utilities.swift
//  WillIBurn
//
//  Created by Alex Hoff on 8/2/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation

class Utilities {
    
    func getStorage() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func setSkinType(value: String) {
        let defaults = getStorage()
        defaults.setValue(value, forKey: defaultsKeys.skinType)
        defaults.synchronize()
    }
    
    func getSkinType() -> String {
        let defaults = getStorage()
        if let result = defaults.string(forKey: defaultsKeys.skinType) {
            return result
        }
        return SkinType().type1
    }
}

