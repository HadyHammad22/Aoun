//
//  HomeVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/28/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    var posts = [Post]()
    static var imageCash: NSCache<NSString, UIImage> = NSCache()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        loadPosts()
    }
    
    func loadPosts(){
        DataService.db.REF_POST.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, post: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.posts = self.posts.sorted(by: { $0.likes > $1.likes})
            self.postsTable.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTable.dequeueReusableCell(withIdentifier: "PostCell") as! HomeCell
        if let img = HomeVC.imageCash.object(forKey: self.posts[indexPath.row].imgUrl as NSString){
            cell.configureCell(post: self.posts[indexPath.row], img: img)
        }else{
            cell.configureCell(post: self.posts[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: self.posts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails"{
            guard let moreDetailsVC = segue.destination as? MoreDetailsVC else {return}
            if let post = sender as? Post{
                moreDetailsVC.post = post
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
   
    
}
