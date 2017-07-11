//
//  ViewController.swift
//  Convert To F
//
//  Created by Alex Hoff on 6/28/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tempEntry: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var numConversions: UILabel!
    var conversionCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func convertClicked(_ sender: Any) {
        if let result = tempEntry.text{
            if result == ""{
                return
            }else{
                if let num = Double(result){
                    let output = num * (9/5) + 32
                    resultLabel.text = String(output)
                    conversionCount += 1;
                    numConversions.text = String(conversionCount) + " Conversions"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

