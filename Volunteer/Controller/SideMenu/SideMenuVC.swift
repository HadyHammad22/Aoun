//
//  SideMenuVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/29/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class SideMenuVC: UIViewController{
    
    @IBOutlet weak var notificationView: CustomView!
    @IBOutlet weak var notificationLabel: UILabel!
    var counter:Int? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        observeUserMessages()
    }
    
    func observeUserMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        DataService.db.REF_USER_MESSAGES.child(uid).observe(.childAdded, with: { (snapshot)in
            DataService.db.REF_MESSAGES.child(snapshot.key).observe(.value, with: { (snapshot)in
                if let dict = snapshot.value as? Dictionary<String,Any>{
                    let msg = Message(msg: dict)
                    if let id = msg.partnerID(), id != Auth.auth().currentUser!.uid{
                        self.counter = self.counter! + 1
                        print("CCC: ",self.counter!)
                    }
                }
            })
        })
        print("DDD: ",counter!)
    }
    @IBAction func buHome(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func buMakePost(_ sender: Any) {
        performSegue(withIdentifier: "Make_Post", sender: nil)
    }
    
    @IBAction func buProfile(_ sender: Any) {
        performSegue(withIdentifier: "Profile", sender: nil)
    }
    
    @IBAction func buShare(_ sender: Any) {
        if let myWebsite = NSURL(string: "") {
            let objectsToShare = ["", myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func buMessages(_ sender: Any) {
       performSegue(withIdentifier: "Messages", sender: nil)
    }
    
    @IBAction func buCharities(_ sender: Any) {
        performSegue(withIdentifier: "Organizations", sender: nil)
    }
    
    @IBAction func buLogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
    
}
