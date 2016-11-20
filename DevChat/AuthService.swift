//
//  AuthService.swift
//  DevChat
//
//  Created by Anton Novoselov on 20/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias CompletionHandler = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: CompletionHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    // If user not found, create new user and sign in
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                // Show error to user
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                
                            } else {
                                
                                // Successfully created the user
                                
                                if user?.uid != nil {
                                    
                                    // Creating new user in Firebase Database
                                    DataService.instance.saveUser(uid: user!.uid)
                                    
                                    // Sign in
                                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            // Show error to user
                                            
                                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                            
                                        } else {
                                            // We have successfully logged in
                                            
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    } else {
                        // Handle all other signIn errors
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                        
                    }
                    
                }
            } else {
                // Successfully logged in
                onComplete?(nil, user)
            }
            
        })
    }
    
    
    
    func handleFirebaseError(error: NSError, onComplete: CompletionHandler?) {
        print(error.debugDescription)
        
        if let errorCode = FIRAuthErrorCode(rawValue: error._code) {
            switch errorCode {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
                
            case .errorCodeAccountExistsWithDifferentCredential:
                fallthrough
            case .errorCodeEmailAlreadyInUse:
                onComplete?("Email already in use", nil)

            default:
                onComplete?("There was a problem authenticating. Try again", nil)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
