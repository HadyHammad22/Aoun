//
//  ChatVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/21/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class ChatVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    var postOwnerID:String? {
        didSet{
            DataService.db.getUserWithId(id: postOwnerID!, completion: { (user) in
                self.navigationItem.title = user!.name
            })
        }
    }
    var messages = [Message]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        observeMessages()
    }
    
    func observeMessages(){
        guard let id = Auth.auth().currentUser?.uid else{return}
        DataService.db.REF_USER_MESSAGES.child(id).observe(.childAdded, with: { (snapshot) in
            DataService.db.REF_MESSAGES.child(snapshot.key).observe(.value, with: { (snapshot) in
                if let dict = snapshot.value as? Dictionary<String,Any>{
                    let msg = Message(msg: dict)
                    if msg.toId == self.postOwnerID!{
                        self.messages.append(msg)
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
        let msg = self.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! ChatMessageCell
        if msg.fromId == Auth.auth().currentUser?.uid{
            cell.configureCell(message: msg, type: .outgoing)
        }else{
            cell.configureCell(message: msg, type: .incoming)
        }
        
        return cell
    }
    
    
   
    
    @IBAction func buSend(_ sender: Any) {
        guard let msgText = messageTextField.text else {
            return
        }
        
        guard let ownerID = postOwnerID else {
            return
        }
        DataService.db.sendMessgaeToFirebase(msg: msgText, ownerID: ownerID, completeion: { result in
            if result{
                print("Message Sent Successfully")
                self.messageTextField.text = nil
            }
        })
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
