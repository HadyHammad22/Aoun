//
//  OrganizationCell.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class OrganizationCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var organizationImage: UIImageView!

    // MARK :- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupComponents()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        cellView.addCornerRadius(15)
        cellView.addNormalShadow()
        organizationImage.layer.cornerRadius = 15
        organizationImage.clipsToBounds = true
    }
    
    func setCell(organiztion: Organization){
        if let image = organiztion.img {
            organizationImage.image = UIImage(named: image)
        }
    }
    
}
