//
//  FeedVC.swift
//  SocialMedia_ShowCase
//
//  Created by Brad Gray on 1/6/16.
//  Copyright © 2016 Brad Gray. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import Alamofire

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textFieldPost: MaterialTxtField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageSelecterImg: UIImageView!
    
  
  var imageSelected = false
    var imagePicker: UIImagePickerController!
    
    var posts = [Posts]()
    //var comments = [Comments]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        tableView.estimatedRowHeight = 358
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            
            self.posts = []
//            self.comments = = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
//                    print("SNAP: \(snap)")
                    
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        let post = Posts(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                       
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
       
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            
            var img: String?
            var username = FIRAuth.auth()?.currentUser?.email
            
            if let url = post.imageUrl {
                img = url
            }
            cell.configureCell(post, img: img, username: username)
            return cell
        } else {
            return PostCell()
        }
           }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }

    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelecterImg.image = image
        imageSelected = true
    }
    @IBAction func makePost(sender: AnyObject) {
       
        
        if let txt = textFieldPost.text where txt != "" {
           
            
            
            if let img = imageSelecterImg.image where imageSelected == true {
                
                let strUrl = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: strUrl)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "238AFTVY077368d453375e56c32e801cae26feb3".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "img/jpg")
                    
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                    }) { encodingResult in
                        print(encodingResult)
                        switch encodingResult {
                            
                        case .Success(let upload, _, _):
                            upload.responseJSON(completionHandler: { response in
                                print("works after Success")
                                
                                if let info = response.result.value as? Dictionary<String,AnyObject> {
                                    print(response.result.value)
                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
                                        print("works after links")
                                        if let imageLink = links["image_link"] as? String {
                                            print("LINK: \(imageLink)")
                                        self.uploadImg(imageLink)
                                        }
                                    }

                                }
                        
                        
                            })
                        case .Failure(let error):
                            print(error)
                        }
                        
            }
            } else {
                self.uploadImg(nil)
            }

        }
    }
    
    
   
    @IBAction func imagePickerTapped(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func uploadImg(imageUrl: String?) {
        
        var post: Dictionary<String, AnyObject> = ["description": textFieldPost.text!, "likes": 0]
        
        if imageUrl != nil {
            post["imageURL"] = imageUrl
        }
        
            let fireBasePost = DataService.ds.REF_POSTS.childByAutoId()
            fireBasePost.setValue(post)
            
            textFieldPost.text = ""
            imageSelecterImg.image = UIImage(named: "camera")
            imageSelected = false
            
            tableView.reloadData()
        
        
    }
    
    
    
    
    
    
}
