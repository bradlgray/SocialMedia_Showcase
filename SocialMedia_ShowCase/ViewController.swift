//
//  ViewController.swift
//  SocialMedia_ShowCase
//
//  Created by Brad Gray on 1/5/16.
//  Copyright © 2016 Brad Gray. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: MaterialTxtField!
    @IBOutlet weak var passwordField: MaterialTxtField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
        }
        
    }
    
    @IBAction func loginBtn(sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        
        
        
        facebookLogin.logInWithReadPermissions(["email"]) { (FacebookResult: FBSDKLoginManagerLoginResult!, FacebookError: NSError!) -> Void in
            if FacebookError != nil {
                print("facebook login failed. Error \(FacebookError)what the heck is going on right now")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                print("succesfuly logged in with facebook \(accessToken)")
//                
//                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
              let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
                    
                
                    if error != nil {
                        print("login failed\(error)")
                    } else {
                        print("we logged in\(user)")
                        
                        let userData = ["provider": credential.provider]
                        DataService.ds.createFirebaseuser((user?.uid)!, user: userData)
                        
                        
                        
                        
                        
                        NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                    }
                })
            }
        }
    }

    @IBAction func attemptLogin(sender: AnyObject) {
        
        if let email = emailField.text where email != "", let pswd = passwordField.text where pswd != "" {
            FIRAuth.auth()?.signInWithEmail(email, password: pswd, completion: { (user, error) in
            
               
                if error != nil {
                    print(error!.code)
                   
                    if error!.code == STATUS_CODE_NONEXIST {
                        
                            FIRAuth.auth()?.createUserWithEmail(email, password: pswd, completion: { (user, error) in
                                
                            
                            if error != nil {
                                self.showAlert("could not create account", msg: "problem creating the account. Try something else.")
                            
                            } else {
                                
                                NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                                
                               
//                                DataService.ds.REF_BASE.authUser(email, password: pswd, withCompletionBlock: { error, authData in
                                    let userData = ["provider": "email"]
                                    DataService.ds.createFirebaseuser((user?.uid)!, user: userData)
                               
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                                
                            }
                        })
                   
                    } else {
                        self.showAlert("could not login", msg: "Please check your username or password")
                    }

                    
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGEDIN, sender: nil)
                }
            })
            
        } else {
            showAlert("email or password required", msg: "enter your email and password")
        }
    }

    func showAlert(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

