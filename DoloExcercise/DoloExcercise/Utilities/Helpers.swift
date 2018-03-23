//
//  Helpers.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

extension String {
    public static let baseUrl = "https://api.foursquare.com/v2/venues/search"
    public static let clientId = "client_id=WTWVJKQOQATHLELVH31WZ2Q2V34M5TEQE1NE0EHYEZ31E443"
    public static let clientSecret = "client_secret=TAGFSMMES2N2D0GQQ4XO4O1ODDBN02QEIMBKBDRVVB3PZ1YA"
    public static let intent = "intent=checkin"
    public static let radius = "radius=500"
    public static let limit = "limit=20"
    public static let version = "v=20180420"
    
    static func buildLocationString(location: Location) -> String {
        var locationString = ""
        
        if let address = location.address {
            locationString += address
        }
        if let crossStreet = location.crossStreet {
            let crossStreetString = " (" + crossStreet + ")"
            locationString += crossStreetString
        }
        if let city = location.city {
            let cityString = ", " + city
            locationString += cityString
        }
        if let state = location.state,
            let zip = location.postalCode {
            let stateZipString = ", " + state + " " + zip
            locationString += stateZipString
        }
        if let country = location.country {
            let countryString = ", " + country
            locationString += countryString
        }
        return locationString
    }
    
    static func buildImageUrlString(icon: Icon) -> String? {
        guard let prefix = icon.prefix,
            let suffix = icon.suffix else { return nil }
        
        let size = "64"
        let url = prefix + size + suffix
        return url
    }
}

extension URL {
    public static func buildLocationUrl(lat: Double, long: Double) -> URL {
        let latLongString = "ll=" + String(describing: lat) + "," + String(describing: long)
        let url = .baseUrl + "?" + latLongString + "&" + .clientId + "&" + .clientSecret + "&" + .intent + "&" + .radius + "&" + .limit + "&" + .version
        return URL(string: url)!
    }
}

fileprivate let imageCache = NSCache<NSString, UIImage>()
fileprivate var imgRequest: AnyObject?

extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let urlKey = urlString as NSString
        
        if let cachedItem = imageCache.object(forKey: urlKey) {
            let newImage = cachedItem.withRenderingMode(.alwaysTemplate)
            self.image = newImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }

        let imageRequest = ImageRequest(url: url)
        imgRequest = imageRequest
        imageRequest.load { (image: UIImage?) in
            if let image = image {
                DispatchQueue.main.async {
                    let newImage = image.withRenderingMode(.alwaysTemplate)
                    imageCache.setObject(newImage, forKey: urlKey)
                    self.image = newImage
                }
            }
        }
    }
}


extension UIColor {
    public static let gradientPink = UIColor(red:0.85, green:0.40, blue:0.55, alpha:1.0)
    public static let gradientPurple = UIColor(red:0.48, green:0.08, blue:0.42, alpha:1.0)
    
    public static let pinkish = UIColor(red:0.85, green:0.40, blue:0.55, alpha:1.0)
    
    public static let offWhite = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    
    public static let bodyBlack = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
    public static let black2 = UIColor(red:0.29, green:0.29, blue:0.29, alpha:1.0)
    
    public static let grey2 = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    public static let grey3 = UIColor(red:0.68, green:0.68, blue:0.68, alpha:1.0)
    public static let grey4 = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
    public static let pinkishGrey = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
    public static let greyBorder = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
    public static let greyBackground = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    public static let greySearchBar = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
}
