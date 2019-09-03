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
        let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func buMakePost(_ sender: Any) {
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
        if let myWebsite = NSURL(string: "") {
            let objectsToShare = ["", myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func buCharities(_ sender: Any) {
        let organizationVC = storyboard?.instantiateViewController(withIdentifier: "OrganizationVC") as! OrganizationVC
        self.present(organizationVC, animated: true, completion: nil)
    }
    
    @IBAction func buLogOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(loginVC, animated: true, completion: nil)
    }
    
}
