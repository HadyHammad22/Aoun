//
//  MainTabBar.swift
//  Volunteer
//
//  Created by Hady Hammad on 11/10/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController, UITabBarControllerDelegate{
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    static var mainIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        menuBtn.target = self.revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if MainTabBar.mainIndex == 0{
            selectedIndex = 0
        }else if MainTabBar.mainIndex == 1{
            selectedIndex = 1
        }else if MainTabBar.mainIndex == 2{
            selectedIndex = 2
        }
        
    }
    
}
