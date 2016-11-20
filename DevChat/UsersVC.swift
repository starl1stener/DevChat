//
//  UsersVC.swift
//  DevChat
//
//  Created by Anton Novoselov on 20/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UsersVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    var selectedUsers = [String: User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
    }
}

























