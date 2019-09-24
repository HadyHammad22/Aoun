//
//  MessagesVCViewController.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/22/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    var messages = [Message]()
    var messagesDictionary = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        observeUserMessages()
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        DataService.db.REF_USER_MESSAGES.child(uid).observe(.childAdded, with: { (snapshot)in
            DataService.db.REF_MESSAGES.child(snapshot.key).observe(.value, with: { (snapshot)in
                if let dict = snapshot.value as? Dictionary<String,Any>{
                    let msg = Message(msg: dict)
                    if let id = msg.partnerID(), id != Auth.auth().currentUser!.uid{
                        self.messagesDictionary[id] = msg
                        self.messages = Array(self.messagesDictionary.values) as! [Message]
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! MessagesCell
        cell.configureCell(message: self.messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.postOwnerID = self.messages[indexPath.row].toId!
        let nav = UINavigationController(rootViewController: chatVC)
        self.present(nav, animated: true, completion: nil)
    }
    
}
