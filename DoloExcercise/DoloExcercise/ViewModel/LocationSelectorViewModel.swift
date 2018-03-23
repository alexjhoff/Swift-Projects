//
//  LocationSelectorViewModel.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum LoadStage {
    case notLoaded
    case loaded
    case reload
    case emptyLoad
}

protocol TableLoadProtocol {
    func tableLoadStage(_ stage: LoadStage)
    func dismissTable(newTitle: String, iconImage: UIImage)
}

class LocationSelectorViewModel: NSObject {
    var tableDelegate: TableLoadProtocol?
    var locationManager: CLLocationManager?
    var locationResults = [LocationCell]()
    var filteredResults = [LocationCell]()
    var isSearch = false
    fileprivate var request: AnyObject?
    
    override init() {
        super.init()
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
        }

        getVenues()
    }
    
    func getVenues() {
        guard let currentLocation = locationManager?.location else {
            return
        }
        let url = URL.buildLocationUrl(lat: currentLocation.coordinate.latitude, long: currentLocation.coordinate.longitude)
        let locationRequest = ApiRequest(url: url)
        request = locationRequest
        locationRequest.load { [weak self] (session: Session?) in
            guard let venues = session?.response?.venues else { return }

            for item in venues {
                guard let name = item.name,
                    let location = item.location else { return }

                if let icon = item.categories?.first?.icon {
                    guard let url = String.buildImageUrlString(icon: icon) else { return }
                    let locationItem = LocationCell(name: name, location: location, currentLocation: currentLocation, imageUrl: url)
                    self?.locationResults.append(locationItem)
                } else {
                    let locationItem = LocationCell(name: name, location: location, currentLocation: currentLocation)
                    self?.locationResults.append(locationItem)
                }
            }
            
            self?.tableDelegate?.tableLoadStage(.loaded)
        }
    }
}

// MARK: - Table view data source
extension LocationSelectorViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredResults.count
        }
        return locationResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as? LocationTableViewCell{
            if isSearch {
                cell.item = filteredResults[indexPath.row]
            } else {
                cell.item = locationResults[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
 
}

// MARK: - Table view delegate
extension LocationSelectorViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let result = tableView.cellForRow(at: indexPath) as? LocationTableViewCell {
            self.tableDelegate?.dismissTable(newTitle: result.nameLabel.text!, iconImage: result.iconImage.image!)
        }
    }
}

 //MARK: - UITextField Delegate
extension LocationSelectorViewModel: UITextFieldDelegate {
    
    // MARK: - Private instance methods
    func filterContentForSearchText(_ searchText: String) {
        isSearch = searchText.isEmpty ? false : true
        
        filteredResults = locationResults.filter({( locationCell : LocationCell) -> Bool in
            return locationCell.name.lowercased().contains(searchText.lowercased())
        })
        
        if filteredResults.isEmpty && !searchText.isEmpty{
            self.tableDelegate?.tableLoadStage(.emptyLoad)
        } else {
            self.tableDelegate?.tableLoadStage(.reload)
        }
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if var text = textField.text {
            if string.isEmpty {
                text.removeLast()
            } else {
                text.append(string)
            }
            filterContentForSearchText(text)
        }
        return true
    }
}

