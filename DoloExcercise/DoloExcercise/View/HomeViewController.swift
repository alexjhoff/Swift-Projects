//
//  HomeViewController.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    var locationEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.layer.cornerRadius = 22
        postButton.layer.borderWidth = 1
        postButton.layer.borderColor = UIColor.white.cgColor
        
        // Set up gradient layer
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [UIColor.gradientPink.cgColor, UIColor.gradientPurple.cgColor]
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func authorizeLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                locationEnabled = false
                let alert = buildDisabledLocationServicesAlert()
                self.present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationEnabled = true
            }
        } else {
            print("Location services are not enabled")
            let locationManager = CLLocationManager()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func buildDisabledLocationServicesAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Location Disabled", message: "Please authorize the app to access your location in iOS Settings to continue", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "iOS Settings", style: .default) { (action: UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
            self.locationEnabled = false
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        authorizeLocationServices()
        if locationEnabled {
            let vc = NewPostViewController(nibName: NewPostViewController.identifier, bundle: nil)
            vc.viewModel = NewPostViewModel()
            self.present(vc, animated: true, completion: nil)
        } else {
            authorizeLocationServices()
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
