//
//  Posts.swift
//  SocialMedia_ShowCase
//
//  Created by Brad Gray on 1/7/16.
//  Copyright © 2016 Brad Gray. All rights reserved.
//

import Foundation

class Posts {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    
    
    var postDescription: String! {
        return _postDescription
    }
    var imageUrl: String? {
        return _imageUrl
    }
    var likes: Int {
        return _likes
    }
    var username: String {
        return _username
    }
    var postKey: String {
        return _postKey
    }
    init(description: String, imageUrl: String?, username: String) {
        _postDescription = description
        _imageUrl = imageUrl
        _username = username
    }
    //used when downloading data from firebase
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        if let imgUrl = dictionary["imageURL"] as? String {
            _imageUrl = imgUrl
        }
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
    }
}