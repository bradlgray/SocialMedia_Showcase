//
//  DataService.swift
//  SocialMedia_ShowCase
//
//  Created by Brad Gray on 1/6/16.
//  Copyright © 2016 Brad Gray. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = URL_BASE
    
    private var _REF_POSTS = URL_BASE.child("posts")
    private var _REF_USERS = URL_BASE.child("users")
   

    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
           }
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    var REF_USERS_CURRENT: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
        let user = URL_BASE.child("Users").child(uid!)
        return user
    }
    
    func createFirebaseuser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(user)
    }
}



