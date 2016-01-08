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

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var posts = [Posts]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
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
            cell.configureCell(post)
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
}
