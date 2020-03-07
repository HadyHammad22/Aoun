//
//  AppDelegate.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/27/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Localizer.localize()
        FirebaseApp.configure()
        configSideMenu()
        //... Setup Navigation
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 52/255, green: 151/255, blue: 253/255, alpha: 1)
        
        //... Go To Login Screen
        if let _ = UserDefaults.standard.string(forKey: KEY_UID) {
            print("Already Login")
        }else{
            //... Go To Main Screen
            window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = LoginVC.instance()
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func configSideMenu() {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let menu = st.instantiateViewController(withIdentifier: "MenuNavigation") as! UISideMenuNavigationController
        menu.menuWidth = (UIScreen.main.bounds.width) * 0.75
        if Language.currentLanguage == .arabic{
            SideMenuManager.default.menuRightNavigationController = menu
        }else{
            SideMenuManager.default.menuLeftNavigationController = menu
        }
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAlwaysAnimate = true
        SideMenuManager.default.menuDismissWhenBackgrounded = true
    }
    
    func initWindow() {
        configSideMenu()
        if Language.currentLanguage == .arabic {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        var darkMode = false
        var preferredStatusBarStyle : UIStatusBarStyle {
            return darkMode ? .default : .lightContent
        }
        setHomeAsRoot()
    }
    
    func setHomeAsRoot(){
        let nav = UINavigationController(rootViewController: MainTabBar.instance())
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

