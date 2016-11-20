//
//  MessagesViewController.swift
//  DevChat
//
//  Created by nag on 20/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

public struct Storyboard {
    
    static let postComposerNVC = "PostComposerNavigationVC"
    
    
}

class MessagesViewController: UIViewController {

    
    var imagePickerHelper: ImagePickerHelper!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tabBarController?.delegate = self

    }

    
    
    
    
}



extension MessagesViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let _ = viewController as? DummyPostViewController {
            
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                
                let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.postComposerNVC) as! UINavigationController
                
                let postComposerVC = postComposerNVC.topViewController as! PostComposerViewController
                
                postComposerVC.image = image
                
                self.present(postComposerNVC, animated: true, completion: nil)
                
            })
            
            return false
        }
        
        return true
        
    }
    
}
