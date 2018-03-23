//
//  LocationTableViewCell.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/21/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {


    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var item: LocationCell? {
        didSet {
            guard let item = item else {
                return
            }
            if let imageUrl = item.imageUrl {
                iconImage.loadImageUsingUrlString(urlString: imageUrl)
            }
            nameLabel.text = item.name
            addressLabel.text = item.address
            
            if let distance = item.distance {
                distanceLabel.text = distance
            }
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutIfNeeded()

        iconImage.tintColor = .grey3
        addressLabel.textColor = .grey3
        distanceLabel.textColor = .grey3
    }
}
