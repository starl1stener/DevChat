//
//  AuthService.swift
//  DevChat
//
//  Created by Anton Novoselov on 20/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    // If user not found, create new user and sign in
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                // Show error to user
                                
                            } else {
                                
                                // Successfully created the user
                                
                                if user?.uid != nil {
                                    
                                    // Sign in
                                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            // Show error to user
                                        } else {
                                            // We have successfully logged in
                                        }
                                    })
                                }
                            }
                        })
                    } else {
                        // Handle all other signIn errors
                        
                    }
                    
                }
            } else {
                // Successfully logged in
            }
            
        })
    }
    
    
}
