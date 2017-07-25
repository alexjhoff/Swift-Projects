//
//  ViewController.swift
//  Picture_Share
//
//  Created by Alex Hoff on 7/20/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var assetCollection: PHAssetCollection?
    var photos: PHFetchResult<PHAsset>?
    var imagePicker: UIImagePickerController!
    let reuseIdentifier = "tableViewCell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        if(collection.firstObject != nil) {
            self.assetCollection = collection.firstObject! as PHAssetCollection
            
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.photos = PHAsset.fetchAssets(in: assetCollection!, options: options)
        }else {
            print("nothing found")
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if(id == "showFullImageSegue"){
                let newVC = segue.destination as! ShowImageViewController
                
                //Good way to get index path when not explicitly passed in
                var indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
                if let asset = self.photos?[(indexPath!.row)] {
                    newVC.asset = asset
                }
            }
        }
        
    }
    
    @IBAction func CameraButtonClicked(_ sender: Any) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion:  nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "showPhotoVC") as! ShowImageViewController
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            newVC.image = image
            show(newVC, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyTableViewCell
        
        if let asset = self.photos?[indexPath.row] {
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 240), contentMode: .aspectFill, options: nil, resultHandler: { (result, info) in
                if let image = result {
                    cell.myImageView?.image = image
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = photos?.count {
            return count
        }
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

