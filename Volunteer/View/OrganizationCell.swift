//
//  OrganizationCell.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class OrganizationCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!

    func setCell(Org:Organization){
        name.text = Org.name!
        address.text = Org.address!
        email.text = Org.email!
        phone.text = Org.phone!
        info.text = Org.info!
        img.image = UIImage(named: Org.img!)
    }
}
