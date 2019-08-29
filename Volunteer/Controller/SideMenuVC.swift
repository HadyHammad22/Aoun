//
//  SideMenuVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/29/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController{

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
    }
    
    @IBAction func buProfile(_ sender: Any) {
        print("Profile")
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
    }
    
}
