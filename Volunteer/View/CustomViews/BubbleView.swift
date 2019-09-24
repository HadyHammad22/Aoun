//
//  BubbleView.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/23/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
@IBDesignable
class BubbleView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
}
