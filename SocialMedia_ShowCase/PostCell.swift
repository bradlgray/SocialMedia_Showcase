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

class PostCell: UITableViewCell {

    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    
    var post: Posts!
    var request: Request?
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        
        if post.imageUrl != nil {
           showcaseImg.kf_setImageWithURL(NSURL(string: post.imageUrl!)!)
            
        }
    }
}
