//
//  MessagesViewController.swift
//  DevChat
//
//  Created by nag on 20/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import FirebaseAuth

public struct Storyboard {
    
    
    static let usersNVC = "usersNVC"
    static let loginVC = "loginVC"
    
    
}

class MessagesViewController: UIViewController {
    
    var mediaPickerHelper: MediaPickerHelper!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self


        // Check if user logged in
        
        guard FIRAuth.auth()?.currentUser != nil else {
            performSegue(withIdentifier: Storyboard.loginVC, sender: nil)
            return
        }
        
        
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UsersVC" {
            
            let navVC = segue.destination as! UINavigationController
            
            if let usersVC = navVC.topViewController as? UsersVC {
                if let videoDict = sender as? [String: URL] {
                    let url = videoDict["videoURL"]
                    usersVC.videoURL = url
                    
                } else if let imageDict = sender as? [String: UIImage] {
                    let image = imageDict["snapshotImage"]
                    usersVC.image = image
                }
                
                
            }
        }
    }
    
    
}

extension MessagesViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let _ = viewController as? DummyPostComposerViewController {
            
            mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
                
                let usersNavigationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.usersNVC) as! UINavigationController
                
                let usersVC = usersNavigationVC.topViewController as! UsersVC
                
                
                if let videoURL = mediaObject as? URL {
                    
                    usersVC.videoURL = videoURL
                    
                } else if let snapshotImage = mediaObject as? UIImage {
                    
                    usersVC.image = snapshotImage
                }
                
                self.present(usersNavigationVC, animated: true, completion: nil)
                
            })
            
        
            
            return false
        }
        
        return true
        
    }

    
    
    
}











