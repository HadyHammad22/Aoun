//
//  HomeVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/28/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var postsTable: UITableView!
    
    var posts = [Post]()
    static var imageCash: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
 
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
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
        let moreDetailsVC = MoreDetailsVC.instance()
        moreDetailsVC.post = self.posts[indexPath.row]
        self.navigationController?.pushViewController(moreDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -300, 10, 0)
        //cell.layer.transform = rotationTransform
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.75){
            //cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
