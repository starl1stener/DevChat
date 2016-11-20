//
//  PostComposerViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 11/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import MobileCoreServices

class PostComposerViewController: UITableViewController {
    
    fileprivate var image: UIImage!
    fileprivate var videoFilePath: String!
    fileprivate var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        if imagePicker == nil && image == nil && videoFilePath == nil {
            
            showPhotoSourceSelection()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        textView.becomeFirstResponder()
        textView.text = ""
        textView.delegate = self
        
        shareBarButtonItem.isEnabled = false
        
        tableView.allowsSelection = false
        
    }
    
    
    func showPhotoSourceSelection() {
        let actionSheet = UIAlertController(title: "Pick New Photo", message: "Would you like to open photos library or camera", preferredStyle: .actionSheet)
        
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
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        imagePicker.sourceType = sourceType
        
//        imagePicker.mediaTypes = [kUTTypeImage as String] // from SYA2-Social
        
        imagePicker.allowsEditing = false
        
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
        
        imagePicker.videoMaximumDuration = 10

        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // From NagSnapChat
    /*
    func showCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: imagePicker.sourceType)!
        imagePicker.videoMaximumDuration = 10
        
        present(imagePicker, animated: true, completion: nil)
    }
    */
    

    func showAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }

    
    @IBAction func cancelDidTap() {
        
        self.image = nil
        self.imageView.image = nil
        textView.resignFirstResponder()
        textView.text = ""
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func shareDidTap(_ sender: Any) {
        
        if let image = image, let caption = textView.text {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBarController = appDelegate.window?.rootViewController as! UITabBarController
            let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
            
            
        }
        
        self.cancelDidTap()
    }
    
    
}

extension PostComposerViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        shareBarButtonItem.isEnabled = textView.text != ""
        
        
    }
    
}


// From NagSnapChat
extension PostComposerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeImage as String {
            // photo
            self.image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.imageView.image = self.image
        } else {
            // video
            videoFilePath = (info[UIImagePickerControllerMediaURL] as! URL).path
            UISaveVideoAtPathToSavedPhotosAlbum(videoFilePath, nil, nil, nil)
        }
        
        dismiss(animated: true, completion: nil)

        
    }
    
    
}



























