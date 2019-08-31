//
//  SideMenuVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/29/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController{
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    @IBAction func buHome(_ sender: Any) {
        print("Home")
        let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func buMakePost(_ sender: Any) {
        print("Make Post")
        let makePostVC = storyboard?.instantiateViewController(withIdentifier: "MakePostVC") as! MakePostVC
        self.present(makePostVC, animated: true, completion: nil)
    }
    
    @IBAction func buProfile(_ sender: Any) {
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @IBAction func buNotifications(_ sender: Any) {
        print("Notifications")
    }
    
    @IBAction func buShareApp(_ sender: Any) {
        print("Share App")
    }
    
    @IBAction func buCharities(_ sender: Any) {
        print("Charities")
    }
    
    @IBAction func buLogOut(_ sender: Any) {
        print("Log Out")
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
    
}
