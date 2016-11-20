//
//  PostComposerViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 11/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class PostComposerViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    var image: UIImage!
    var imagePickerSourceType: UIImagePickerControllerSourceType!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.becomeFirstResponder()
        textView.text = ""
        textView.delegate = self
        
        shareBarButtonItem.isEnabled = false
        imageView.image = self.image
        
        tableView.allowsSelection = false
        
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
    
    
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
}

extension PostComposerViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        shareBarButtonItem.isEnabled = textView.text != ""
        
        
    }
    
}






























