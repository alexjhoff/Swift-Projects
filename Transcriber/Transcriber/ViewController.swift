//
//  ViewController.swift
//  Transcriber
//
//  Created by Alex Hoff on 7/26/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //runs transcribe permissions if no errors
    func requestRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission() {
            [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    //get transcription permissions
                    self.requestTranscribePermissions()
                }else {
                    //error
                    self.showError()
                    
                }
            }
        }
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization {
            [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    //good to go
                    self.dismiss(animated: true, completion: nil)
                }else {
                    //error
                    self.showError()

                }
            }
        }
    }
    
    func showError() {
        self.label.text = "You have previously denied this application access to speech recognition. Please change in settings and restart the app!"
        self.disableButton()
    }
    
    func disableButton() {
        self.button.isEnabled = false
        UIView.animate(withDuration: 1.0) { 
            self.button.alpha = 0.3
        }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        requestRecordPermissions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

