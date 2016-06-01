//
//  PostCell.swift
//  SocialMedia_ShowCase
//
//  Created by Brad Gray on 1/6/16.
//  Copyright © 2016 Brad Gray. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
     var post: Posts?
    var request: Request?
    var likeRef: FIRDatabaseReference!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
            }
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width
        profileImg.clipsToBounds = true
        showcaseImg.clipsToBounds = true
        

    }

    func configureCell(post: Posts, img: String?) {
        
        self.post = post
        
         self.descriptionText.text = post.postDescription
        self.likeLbl.text = "\(post.likes)"
        likeRef = DataService.ds.REF_USERS_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        
        if post.imageUrl != nil {
           showcaseImg.kf_setImageWithURL(NSURL(string: post.imageUrl!)!)
            
        }
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesnotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-empty")
                
            } else {
               
            }
        
        })
        
    }
    func likeTapped(sender:UITapGestureRecognizer) {
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesnotExist = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart-full")
                self.post!.adjustLikes(true)
                self.likeRef.setValue(true)
               
            } else {
                 self.likeImg.image = UIImage(named: "heart-empty")
                self.post!.adjustLikes(false)
                self.likeRef.removeValue()
            }
            self.likeLbl.text = "\(self.post!.likes)"
        })
        
        
        }

        
    }

