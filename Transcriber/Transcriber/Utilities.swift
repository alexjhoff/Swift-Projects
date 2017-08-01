//
//  Utilities.swift
//  Transcriber
//
//  Created by Alex Hoff on 7/27/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

class Utilities
{
    var dateTimeString: String?
    
    //Function gets the document directory to write to locally
    func getDocsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirectory = paths[0]
        return docsDirectory
    }
    
    func getAudioFileUrl() -> URL? {
        do {
            let audioUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".m4a")
            return audioUrl
        }catch _ {
            return nil
        }
    }
    
    func getTextFileUrl() -> URL? {
        do {
            let textUrl = try getDocsDirectory().appendingPathComponent(getDateAndTime() + ".txt")
            return textUrl
        }catch _ {
            return nil
        }
    }
    
    func getDateAndTime() -> String {
        if let dateT = dateTimeString {
            return dateT
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    func ShowAlert(title: String, message: String, vc: UIViewController) -> String? {
        var fileNameField: UITextField = UITextField()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "File name"
            fileNameField = textField
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("Text input : \(fileNameField.text)")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

        vc.present(alert, animated: true, completion: nil)
        return fileNameField.text
    }

}
