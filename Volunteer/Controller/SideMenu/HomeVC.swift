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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let call = UIContextualAction(style: .normal, title: nil, handler: { (action,view,nil) in
            self.loadData(id: self.posts[indexPath.row].id, completion: { (user) in
                guard let user = user else{return}
                print(user.phone)
                guard let url = URL(string: "telprompt://\(user.phone)") else {return}
                UIApplication.shared.open(url)
            })
        })
        
        call.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        call.image = UIGraphicsImageRenderer(size: CGSize(width: 60, height: 60)).image { _ in
            UIImage(named: "call")?.draw(in: CGRect(x: 0, y: 0, width: 60, height: 60))
        }
        
        let chat = UIContextualAction(style: .normal, title: nil, handler: { (action,view,nil) in
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            chatVC.postOwnerID = self.posts[indexPath.row].id
            let nav = UINavigationController(rootViewController: chatVC)
            self.present(nav, animated: true, completion: nil)
        })
        chat.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        chat.image = UIGraphicsImageRenderer(size: CGSize(width: 60, height: 70)).image { _ in
            UIImage(named: "chat-box")?.draw(in: CGRect(x: 0, y: 0, width: 60, height: 70))
        }
        
        if self.posts[indexPath.row].id == Auth.auth().currentUser?.uid{
            let config = UISwipeActionsConfiguration(actions: [call])
            config.performsFirstActionWithFullSwipe = false
            return config
        }
        
        let config = UISwipeActionsConfiguration(actions: [chat,call])
        config.performsFirstActionWithFullSwipe = false
        return config    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func loadData(id: String,completion: @escaping (_ user: User?)->()){
        DataService.db.REF_USERS.child(id).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? Dictionary<String,Any> else{return}
            let user = User(userData: data)
            completion(user)
        })
    }
}
