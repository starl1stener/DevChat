//
//  DataSevice.swift
//  DevChat
//
//  Created by Anton Novoselov on 20/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import FirebaseDatabase


let FIR_CHILD_USERS = "users"


class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
        
    }
    
    var userRef: FIRDatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, Any> = [
            "firstName": "",
            "lastName": ""
        ]
        
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    
}












