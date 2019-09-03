//
//  HomeCell.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class HomeCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var DonationType: UILabel!
    @IBOutlet weak var likes: UILabel!
    
    func configureCell(post: Post, img:UIImage? = nil){
        
        self.postText.text = post.postText
        self.likes.text = "\(post.likes)"
        self.DonationType.text = post.type
        if img != nil{
            self.postImage.image = img
        }else{
            let ref = Storage.storage().reference(forURL: post.imgUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data,error) in
                if error != nil{
                    print("Unable To Download Image From Firebase Storage")
                }else{
                    print("Image Downloaded Successfully From Firebase Storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImage.image = img
                            HomeVC.imageCash.setObject(img, forKey: post.imgUrl as NSString)
                        }
                    }
                }
            })
        }
    }
    
    
}
