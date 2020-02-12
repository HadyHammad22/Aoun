//
//  SideMenuVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/29/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class SideMenuVC: UIViewController {
    
    @IBOutlet weak var notificationView: CustomView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    var counter:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserName()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("load observation")
        observeNotifications()
    }
    
    func setupUserName(){
        DataService.db.getUserWithId(id: Auth.auth().currentUser!.uid, completion: { user in
            self.userName.text = user?.name
        })
    }
    
    func observeNotifications(){
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        DataService.db.NOTIFICATION.child(uid).observe(.value, with: { (snapshot) in
            print(snapshot.childrenCount)
            if snapshot.childrenCount > 0{
                self.notificationLabel.text = "\(snapshot.childrenCount)"
                self.notificationView.isHidden = false
            }else{
                self.notificationView.isHidden = true
            }
        })
        
    }
    
    @IBAction func buHome(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        MainTabBar.mainIndex = 0
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func buMakePost(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        MainTabBar.mainIndex = 1
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func buProfile(_ sender: Any) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        MainTabBar.mainIndex = 2
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func buMessages(_ sender: Any) {
        self.performSegue(withIdentifier: "messages", sender: nil)
    }
    
    @IBAction func buCharities(_ sender: Any) {
        self.performSegue(withIdentifier: "charities", sender: nil)
    }
    
    @IBAction func buShare(_ sender: Any) {
        
        if let myWebsite = NSURL(string: "") {
            let objectsToShare = ["", myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func buLogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
    
}
