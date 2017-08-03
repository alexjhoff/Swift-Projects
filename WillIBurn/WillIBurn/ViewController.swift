//
//  ViewController.swift
//  WillIBurn
//
//  Created by Alex Hoff on 8/2/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var coords = CLLocationCoordinate2D(latitude: 40, longitude: 40)
    var skinType = SkinType().type1 {
        didSet {
            skinTypeLabel.text = "Skin: " + self.skinType
            Utilities().setSkinType(value: skinType)
            getWeatherData()
        }
    }
    var uvIndex = 8
    var burnTime: Double = 10
    
    @IBOutlet var skinTypeLabel: UILabel!
    @IBOutlet var searchingLabel: UILabel!
    @IBOutlet var searchingActivity: UIActivityIndicatorView!
    @IBOutlet var bigTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        skinType = Utilities().getSkinType()
        skinTypeLabel.text = "Skin: " + skinType
    }

    @IBAction func changeSkinClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Skin Type", message: "Please choose skin type.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: SkinType().type1, style: .default, handler: { (action) in
            self.skinType = SkinType().type1
        }))
        alert.addAction(UIAlertAction(title: SkinType().type2, style: .default, handler: { (action) in
            self.skinType = SkinType().type2
        }))
        alert.addAction(UIAlertAction(title: SkinType().type3, style: .default, handler: { (action) in
            self.skinType = SkinType().type3
        }))
        alert.addAction(UIAlertAction(title: SkinType().type4, style: .default, handler: { (action) in
            self.skinType = SkinType().type4
        }))
        alert.addAction(UIAlertAction(title: SkinType().type5, style: .default, handler: { (action) in
            self.skinType = SkinType().type5
        }))
        alert.addAction(UIAlertAction(title: SkinType().type6, style: .default, handler: { (action) in
            self.skinType = SkinType().type6
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func remindButtonClicked(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Time's Up!", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "You are beginning to burn! Put on sunscreen or get out of the sun.", arguments: nil)
                content.sound = UNNotificationSound.default()
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "willburn", content: content, trigger: trigger)
                
                center.add(request, withCompletionHandler: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Alex location changed")
        
        if status == .authorizedWhenInUse {
            getLocation()
        }else if status == .denied {
            let alert = UIAlertController(title: "Error", message: "Go to settings and allow location servies", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getLocation () {
        if let loc = locationManager.location?.coordinate {
            coords = loc
        }
    }
    
    func getWeatherData() {
        let url = WeatherUrl(lat: String(coords.latitude), long: String(coords.longitude)).getFullUrl()
        print("Alex url \(url)")
        
        Alamofire.request(url, method:.get).responseJSON { (response) in
            print("alamo \(response.result)")
            
            if let JSON = response.result.value as? [String:Any]{
                print("JSON \(JSON)")
                
                if let data = JSON["data"] as? Dictionary<String, AnyObject> {
                    if let weather = data["weather"] as? [Dictionary<String, AnyObject>] {
                        if let uv = weather[0]["uvIndex"] as? String {
                            if let uvI = Int(uv) {
                                self.uvIndex = uvI
                                print("Alex UVIndex = \(uvI)")
                                self.updateUI(dataSuccess: true)
                                return
                            }
                        }
                    }
                }
                
            }
            self.updateUI(dataSuccess: false)
        }
        
    }
    
    func updateUI (dataSuccess: Bool) {
        DispatchQueue.main.async {
            //failed
            if !dataSuccess {
                self.searchingLabel.text = "Failed...retrying..."
                self.getWeatherData()
                return
            }
            
            //success!
            self.searchingActivity.stopAnimating()
            self.searchingLabel.text = "Recieved UV data"
            self.calculateBurnTime()
            print("Alex burn time: \(self.burnTime)")
            self.bigTimeLabel.text = String(format: "%.1f", self.burnTime)
        }
    }
    
    func calculateBurnTime() {
        var minToBurn: Double = 10
        
        switch skinType {
        case SkinType().type1:
            minToBurn = BurnTime().burnType1
        case SkinType().type2:
            minToBurn = BurnTime().burnType2
        case SkinType().type3:
            minToBurn = BurnTime().burnType3
        case SkinType().type4:
            minToBurn = BurnTime().burnType4
        case SkinType().type5:
            minToBurn = BurnTime().burnType5
        case SkinType().type6:
            minToBurn = BurnTime().burnType6
        default:
            minToBurn = BurnTime().burnType1
        }
        burnTime = minToBurn / Double(self.uvIndex)
    }

}

