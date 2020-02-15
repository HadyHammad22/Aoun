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
    
    // MARK :- Outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var counter:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        setupUser()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        topView.addNormalShadow()
        userImage.addCornerRadius(userImage.frame.height / 2)
    }
    
    func setupUser(){
        DataService.db.getUserWithId(id: Auth.auth().currentUser!.uid, completion: { user in
            self.userNameLbl.text = user?.name
            self.userEmailLbl.text = user?.email
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
    
    @IBAction func buLanguage(_ sender: Any) {
        
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
