//
//  RecordViewController.swift
//  Transcriber
//
//  Created by Alex Hoff on 7/27/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRec: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var recFileUrl: URL!
    var textFileUrl: URL!
    var transcribed: Bool = false
    var recName: String?
    
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var activityLabel: UIActivityIndicatorView!
    @IBOutlet var playbackButton: UIButton!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let utils = Utilities()
        recFileUrl = utils.getAudioFileUrl()
        textFileUrl = utils.getTextFileUrl()
        
        print("alex" + recFileUrl!.absoluteString)
        recordingLabel.alpha = 0
        activityLabel.alpha = 0
        playbackButton.alpha = 0
        playbackButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonClicked(_ sender: UIButton) {
        recordAudio()
    }

    @IBAction func stopButtonClicked(_ sender: UIButton) {
        stopRecording(sender: sender)
    }
    
    func stopRecording(sender: UIButton) {
        audioRec?.stop()
        sender.titleLabel?.text = "Finished"
        sender.isEnabled = false
        sender.alpha = 0.2
        activityLabel.stopAnimating()
        UIView.animate(withDuration: 0.5) {
            self.activityLabel.alpha = 0
            self.recordingLabel.alpha = 0
            self.playbackButton.alpha = 1
        }
        playbackButton.isEnabled = true
        setAudioPlayer()
        transcribeAudio()
        recName = Utilities().ShowAlert(title: "File Name", message: "Please enter the audio file's name", vc: self)
        print("Alex rec " + recName!)
    }
    
    @IBAction func playbackRecordingButtonClicked(_ sender: UIButton) {
        
        setAudioPlayer()
        audioPlayer?.play()
    }
    
    func setAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recFileUrl)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - Audio Recording
    func recordAudio() {

        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRec = try AVAudioRecorder(url: recFileUrl, settings: settings)
            audioRec?.delegate = self
            audioRec?.record()
            UIView.animate(withDuration: 0.5, animations: {
                self.activityLabel.alpha = 1
                self.recordingLabel.alpha = 1
            })
            activityLabel.startAnimating()
            
        } catch let error {
            //failed recording
            print("alex failed recording \(error)")
            recordingEnded(sucess: false)
        }
    }
    
    func recordingEnded(sucess: Bool) {
        audioRec?.stop()
        if sucess {
            //transcribe audio
            audioPlayer?.stop()
        }
    }
    
    
    // MARK: - Audio Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recordingEnded(sucess: false)
        } else {
            recordingEnded(sucess: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer?.stop()
        //if transcribed {
        CoreDataHelper().storeTranscription(audioFileUrlString: recName!, textFileUrlString: String(describing: textFileUrl), vc: self)
        //}
    }

    // MARK: - Transcribe
    func transcribeAudio() {
        print("Alex text write")
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: recFileUrl)
        
        recognizer?.recognitionTask(with: request) {
            [unowned self] (result, error) in
            
            guard let result = result else {
                print("alex " + String(describing: error!))
                return
            }
            
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                
                self.textView.text = text
                do {
                    try text.write(to: self.textFileUrl, atomically: true, encoding: String.Encoding.utf8)
                    self.transcribed = true
                } catch {
                    
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
