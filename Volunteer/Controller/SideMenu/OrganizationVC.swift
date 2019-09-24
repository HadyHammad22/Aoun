//
//  OrganizationVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
class OrganizationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    var listOfOrganization = [Organization]()
    var listOfURLs = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        listOfOrganization = Organization.loadOrganizations()
        loadURLs()
    }
    
    func loadURLs(){
        listOfURLs.append("https://myf-egypt.org/newWeb/")
        listOfURLs.append("https://misrelkheir.org/en/")
        listOfURLs.append("https://www.egyptianfoodbank.com/en")
        listOfURLs.append("http://www.dar-alorman.com/home/")
        listOfURLs.append("https://www.57357.org")
        listOfURLs.append("https://resala.org")
        listOfURLs.append("https://www.ahl-masr.org")
        listOfURLs.append("https://aljoud-ngo.com")
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfOrganization.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrgInfo", for: indexPath) as! OrganizationCell
        cell.setCell(Org: listOfOrganization[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: listOfURLs[indexPath.row]), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
}
