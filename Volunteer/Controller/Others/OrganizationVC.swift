//
//  OrganizationVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
class OrganizationVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> OrganizationVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OrganizationVC") as! OrganizationVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK :- Instance Variables
    var listOfOrganization = [Organization]()
    var listOfURLs = [String]()
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension OrganizationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfOrganization.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrgInfo", for: indexPath) as! OrganizationCell
        cell.setCell(organiztion: listOfOrganization[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: listOfURLs[indexPath.row]), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
