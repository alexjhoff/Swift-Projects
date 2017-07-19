//
//  SecondViewController.swift
//  Time_Travel
//
//  Created by Alex Hoff on 7/19/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func travelClicked(_ sender: Any) {
        let utils = Utilities()
        let year = utils.GetRandomYear()
        
        label1.text = utils.GetLetterAtIndex(str: year, location: 0)
        label2.text = utils.GetLetterAtIndex(str: year, location: 1)
        label3.text = utils.GetLetterAtIndex(str: year, location: 2)
        label4.text = utils.GetLetterAtIndex(str: year, location: 3)
        
        animateItem(duration: 0.5, delay: 0, object: label1)
        animateItem(duration: 0.5, delay: 0.2, object: label2)
        animateItem(duration: 0.5, delay: 0.4, object: label3)
        animateItem(duration: 0.5, delay: 0.6, object: label4)
    }

    //All objects are a subclass of UIView
    func animateItem(duration: Double, delay: Double, object: UIView) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            object.center.x += self.view.bounds.width
        }) { (true) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

