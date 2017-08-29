//
//  DataModels.swift
//  RSSReader
//
//  Created by Alex Hoff on 8/28/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation

//Holds feeds
class Feed {
    
    var id: Int64?
    var name: String?
    var address: String?
    
    init? (id: Int64, name:String, address:String) {
        self.id = id
        self.name = name
        self.address = address
        
        if name.isEmpty || address.isEmpty {
            return nil
        }
    }
    
}

class FeedItem {
    
    var title: String
    var description: String
    var link: String
    
    init (title: String, description: String, link:String) {
        self.title = title
        self.description = description
        self.link = link
    }
    
    R
}
