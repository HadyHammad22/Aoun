//
//  CircleImageView.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/22/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
@IBDesignable
class CustomImageView: UIImageView{
    @IBInspectable var cornerRadius:CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
