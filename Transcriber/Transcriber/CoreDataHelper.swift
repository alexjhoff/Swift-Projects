//
//  CoreDataHelper.swift
//  Transcriber
//
//  Created by Alex Hoff on 7/28/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper
{
    
    init() {
        //checking if core data is available app wide
        let container = NSPersistentContainer(name: "Transcriber")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print("Alex \(error)")
            } else {
                print("Alex core data fine")
            }
        }
    }
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeTranscription(audioFileUrlString: String, textFileUrlString: String, vc: UIViewController) {
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Transcription", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        transc.setValue(audioFileUrlString, forKey: "audioFileUrlString")
        transc.setValue(textFileUrlString, forKey: "textFileUrlString")
        
        do {
            try context.save()
            print("Alex saved")
        } catch {
            
        }
    }
    
    func getTranscriptions() -> [NSManagedObject]? {
        
        let fetchRequest: NSFetchRequest<Transcription> = Transcription.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            print("Alex num of results = \(searchResults.count)")
            
            for trans in searchResults as [NSManagedObject] {
                print("Alex Result: \(trans.value(forKey: "audioFileUrlString"))")
            }
            return searchResults as [NSManagedObject]
        } catch {
            return nil
        }
        
    }
    
}
