//
//  ImageView.swift
//  Volunteer
//
//  Created by Hady Hammad on 10/20/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
extension UIImageView{
    func setImage(imageUrl: String){
        self.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage.init(named: "needed"), options: .continueInBackground) { (imagee, _,_ , _) in
            if let img = imagee{
                self.image = img
            }else{
                self.image = UIImage.init(named: "needed")
            }
        }
    }
}
