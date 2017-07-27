//
//  Utilities.swift
//  ChatApp
//
//  Created by Alex Hoff on 7/25/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    //Important basic code for any alert
    func ShowAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func GetDate() -> String {
        let today: Date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: today)
    }
}
