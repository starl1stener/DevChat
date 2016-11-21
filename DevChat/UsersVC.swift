//
//  UsersVC.swift
//  DevChat
//
//  Created by Anton Novoselov on 20/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    var selectedUsers = [String: User]()
    
    private var _image: UIImage?
    private var _videoURL: URL?
    
    
    var image: UIImage? {
        set {
            _image = newValue
            print("===NAG=== image = \(image)")
        }
        get {
            return _image
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
            print("===NAG=== videoURL = \(videoURL)")
        }
        get {
            return _videoURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        
        
        DataService.instance.userRef.observeSingleEvent(of: .value, with: {
            (snapshot: FIRDataSnapshot) in
            
//            print("===NAG=== Snap: \(snapshot.debugDescription)")
            
            if let users = snapshot.value as? [String: Any] {
                
                for (key, value) in users {
                    if let dict = value as? [String: Any] {
                        if let profile = dict["profile"] as? [String: Any] {
                            
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                            
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            print("===NAG=== Users: \(self.users)")
        })
    }
    
    
    
    
    
    

    @IBAction func sendPRBtnPressed(sender: AnyObject) {
        
        if let url = _videoURL {
            
            print("===NAG=== url = \(url)")
            
            let videoName = "\(NSUUID().uuidString)\(url)"
            print("===NAG=== videoName = \(videoName)")
            
            let ref = DataService.instance.videosStorageRef.child(videoName)
            
            _ = ref.putFile(url, metadata: nil, completion: { (meta: FIRStorageMetadata?, error: Error?) in
                
                if error != nil {
                    print("===NAG=== Unable to upload video to Firebase Storage")

                    GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: "Error upload video", message: (error?.localizedDescription)!, buttonTitle: "OK")
                } else {
                    print("===NAG=== Successfully video uploaded to Firebase Storage")

                    let downloadURL = meta!.downloadURL()
                    
                    // save this somewhere
                    
                    print("===NAG=== downloadURL = \(downloadURL)")
                    
                    DataService.instance.sendMediaPullRequest(senderUID: (FIRAuth.auth()?.currentUser?.uid)!, sendingTo: self.selectedUsers, mediaURL: downloadURL!, textSnippet: "Text Snippet for video snap")
                    
                    
                    
                }
                
            })
            self.dismiss(animated: true, completion: nil)

        } else if let image = _image {
            if let imageData = UIImageJPEGRepresentation(image, 0.2) {
                
                let imageUid = NSUUID().uuidString
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                
                let ref = DataService.instance.imagesStorageRef.child("\(imageUid).jpg")
                
                _ = ref.put(imageData, metadata: metaData, completion: { (meta: FIRStorageMetadata?, error: Error?) in
                    if error != nil {
                        print("===NAG=== Unable to upload image to Firebase Storage")
                        
                        GeneralHelper.sharedHelper.showAlertOnViewController(viewController: self, withTitle: "Error upload image", message: (error?.localizedDescription)!, buttonTitle: "OK")
                    } else {
                        print("===NAG=== Successfully image uploaded to Firebase Storage")
                        let downloadURL = meta!.downloadURL()
                        
                        print("===NAG=== downloadURL = \(downloadURL)")
                        
                        DataService.instance.sendMediaPullRequest(senderUID: (FIRAuth.auth()?.currentUser?.uid)!, sendingTo: self.selectedUsers, mediaURL: downloadURL!, textSnippet: "Text snippet for image snap")
                        
                    }
                })
                
                self.dismiss(animated: true, completion: nil)

                
            }
        }
        
        
    }
    
}


extension UsersVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        
        
        return cell
        
    }
}

extension UsersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
}

























