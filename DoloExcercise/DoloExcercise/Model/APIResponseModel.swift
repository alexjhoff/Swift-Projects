//
//  APIResponseModel.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

struct Session: Codable {
    let meta: Meta?
    let response: Response?
}

struct Meta: Codable {
    let code: Int?
    let errorType: String?
    let errorDetail: String?
    let requestId: String?
}

struct Response: Codable {
    let venues: [Venue]?
}

struct Venue: Codable {
    let id: String?
    let name: String?
    let location: Location?
    let categories: [Categories]?
}

struct Location: Codable {
    let lat: Double
    let lng: Double
    let address: String?
    let crossStreet: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
}

struct Categories: Codable {
    let id: String?
    let name: String?
    let icon: Icon?
}

struct Icon: Codable {
    let prefix: String?
    let suffix: String?
}
