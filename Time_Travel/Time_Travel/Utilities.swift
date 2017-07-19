//
//  Utilities.swift
//  Time_Travel
//
//  Created by Alex Hoff on 7/19/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation

class Utilities {
    
    func GetCurrentYear () -> String {
        let date = Date()
        let calendar = Calendar.current
        return String(calendar.component(.year, from: date))
    }
    
    //Swift doesnt allow for index calls on strings VERY USEFUL FUNCTION FOR STRING MANIPULATION
    func GetLetterAtIndex (str: String, location: Int) -> String {
        let index = str.index(str.startIndex, offsetBy: location)
        return String(str[index])
    }
    
    func GetCurrentTime() -> String {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        
        let timeString = formatter.string(from: date)
        
        return timeString
    }
    
    func GetRandomYear() -> String {
        return String(arc4random_uniform(8999) + 1000)
    }
    
}
