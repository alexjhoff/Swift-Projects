//
//  NewPostViewModel.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/22/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

fileprivate let headlineId = "headlineTextView"
fileprivate let bodyId = "bodyTextView"
fileprivate let headlinePlaceholder = "Headline"
fileprivate let bodyPlaceholder = "Body"

protocol NewPostProtocol {
    func animateTextViewHeightTo(_ height: CGFloat)
    func pickedImage(_ image: UIImage)
}

class NewPostViewModel: NSObject {
    var newPostDelegate: NewPostProtocol?
}

extension NewPostViewModel: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == headlinePlaceholder || textView.text == bodyPlaceholder {
            textView.text = ""
            textView.textColor = .bodyBlack
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.restorationIdentifier == headlineId {
            guard let lineHeight = textView.font?.lineHeight else { return }
            let numberOfLines = textView.contentSize.height/lineHeight
            let lines = Int(numberOfLines)

            switch lines {
            case 2:
                newPostDelegate?.animateTextViewHeightTo(56)
            case 3:
                newPostDelegate?.animateTextViewHeightTo(79)
            case 4:
                newPostDelegate?.animateTextViewHeightTo(89)
            default:
                break
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView.restorationIdentifier == headlineId {
                textView.text = headlinePlaceholder
            } else {
                textView.text = bodyPlaceholder
            }
            textView.textColor = .pinkishGrey
        }
    }
}

extension NewPostViewModel: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newPostDelegate?.pickedImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
