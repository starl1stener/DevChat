//
//  MediaPickerHelper.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 08/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import MobileCoreServices

typealias MediaPickerHelperCompletion = ((Any?) -> Void)!

class MediaPickerHelper: NSObject {
    
    // actionsheet, imagePickerController ==> viewController
    
    weak var viewController: UIViewController!
    
    var completion: MediaPickerHelperCompletion
    
    
    init(viewController: UIViewController, completion: MediaPickerHelperCompletion) {
        self.viewController = viewController
        self.completion = completion
        
        super.init()
        
        self.showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        let actionSheet = UIAlertController(title: "Pick New Media", message: "Would you like to open photos library or camera", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            
            self.showImagePicker(sourceType: .camera)

            
        })
        
        let photosLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            
            self.showImagePicker(sourceType: .photoLibrary)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photosLibraryAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = sourceType

//        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        imagePicker.allowsEditing = false
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!

        imagePicker.videoMaximumDuration = 10

        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    
}



extension MediaPickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        viewController.dismiss(animated: true, completion: nil)
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeImage as String {
            // photo
            
            let snapshotImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
//            self.image = snapshotImage
//            self.imageView.image = self.image
            
            completion(snapshotImage)
            
            
        } else {
            // video
            //            videoFilePath = (info[UIImagePickerControllerMediaURL] as! URL).path
            //            UISaveVideoAtPathToSavedPhotosAlbum(videoFilePath, nil, nil, nil)
            
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            
            completion(videoURL)
            
        }
        
   
        
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        
        
    }
    
    
    
}


























