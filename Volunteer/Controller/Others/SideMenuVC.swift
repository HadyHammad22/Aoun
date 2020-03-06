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
    
    // MARK :- Instance
    static func instance () -> SideMenuVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var counter:Int = 0
    static var delegate: IndexChangeDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupComponents()
        setupUser()
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
        self.dismiss(animated: true, completion: {
            SideMenuVC.delegate?.changeTabBarIndex(index: 0)
        })
    }
    
    @IBAction func buMakePost(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            SideMenuVC.delegate?.changeTabBarIndex(index: 1)
        })
    }
    
    @IBAction func buProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            SideMenuVC.delegate?.changeTabBarIndex(index: 2)
        })
    }
    
    @IBAction func buLanguage(_ sender: Any) {
        if Language.currentLanguage == .arabic {
            dismiss(animated: true, completion: {
                Language.swichLanguage()
                UIApplication.initWindow()
            })
        }else{
            dismiss(animated: true, completion: {
                Language.swichLanguage()
                UIApplication.initWindow()
            })
        }
    }
    
    @IBAction func buCharities(_ sender: Any) {
        self.navigationController?.pushViewController(OrganizationVC.instance(), animated: true)
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
