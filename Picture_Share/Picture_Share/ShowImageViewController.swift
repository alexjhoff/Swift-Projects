//
//  ShowImageViewController.swift
//  Picture_Share
//
//  Created by Alex Hoff on 7/21/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit
import Photos
import Social

class ShowImageViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    var asset: PHAsset?
    var image: UIImage?
    var docController: UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let myAsset = asset {
            PHImageManager.default().requestImage(for: myAsset, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.width * 0.5625), contentMode: .aspectFill, options: nil, resultHandler: { (result, info) in
                if let image = result {
                    self.imageView.image = image
                }
            })
        }else if(image != nil){
            self.imageView.image = image
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook){
                ShareFacebookTwitter(vc: vc)
            }
        case 1:
            ShareInstagram()
        case 2:
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter){
                ShareFacebookTwitter(vc: vc)
            }
        case 3:
            ShareWhatsApp()
        default:
            print("none")
        }
    }

    func ShareFacebookTwitter(vc: SLComposeViewController) {
        vc.setInitialText("Look at this picture!")
        vc.add(imageView.image)
        vc.add(URL(string: "https://github.com/alexjhoff"))
        present(vc, animated: true, completion: nil)
    }
    
    func ShareInstagram() {
        
        let instagramUrl = URL(string: "instagram://app")
        
        if(UIApplication.shared.canOpenURL(instagramUrl!)) {
            let imageData = UIImageJPEGRepresentation(imageView.image!, 90)
            let captionString = "Default text"
            
            let writePath = (NSTemporaryDirectory() as NSString).appending("instagram.igo")
            
            do {
                try imageData?.write(to: URL(fileURLWithPath: writePath), options: [.atomicWrite])
                let fileURL = URL(fileURLWithPath: writePath)
                
                self.docController = UIDocumentInteractionController(url: fileURL)
                self.docController?.delegate = self
                self.docController?.uti = "com.instagram.exclusivegram"
                self.docController?.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                self.docController?.presentOpenInMenu(from: self.view.frame, in:self.view, animated: true)
                
            } catch _ {
                print("error instagram")
            }
        }
        
    }
    
    func ShareWhatsApp() {
        let urlWhats = "whatsapp://app"
        
        if let whatsappURL = URL(string: urlWhats) {
            
            if UIApplication.shared.canOpenURL(whatsappURL) {
                if let image = imageView.image {
                    if let imageData = UIImageJPEGRepresentation(image, 90) {
                        do {
                            let tempFile = try URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                            try imageData.write(to: tempFile, options: .atomicWrite)
                            self.docController = UIDocumentInteractionController(url: tempFile)
                            self.docController?.uti = "net.whatapp.image"
                            self.docController?.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
                        } catch _ {
                            print("whatsapp error")
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
