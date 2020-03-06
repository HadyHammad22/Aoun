//
//  MainTabBar.swift
//  Volunteer
//
//  Created by Hady Hammad on 11/10/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import SideMenu

protocol IndexChangeDelegate {
    func changeTabBarIndex(index: Int)
}

class MainTabBar: UITabBarController, IndexChangeDelegate{
    
    // MARK :- Instance
    static func instance () -> MainTabBar{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBar
    }
    
    static var mainIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuVC.delegate = self
        let rightMenuNavigationController = UISideMenuNavigationController(rootViewController: SideMenuVC.instance())
        rightMenuNavigationController.menuWidth = self.view.frame.width*0.7
        SideMenuManager.default.menuRightNavigationController = rightMenuNavigationController
        
        let leftMenuNavigationController = UISideMenuNavigationController(rootViewController: SideMenuVC.instance())
        leftMenuNavigationController.menuWidth = self.view.frame.width*0.7
        SideMenuManager.default.menuLeftNavigationController = leftMenuNavigationController
        
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    @IBAction func buMenu(_ sender: Any) {
        if Language.currentLanguage == .english{
            present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        }else{
            present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
        }
    }
    
    // MARK :- Confirm Protocol
    func changeTabBarIndex(index: Int) {
        selectedIndex = index
    }
    
}
