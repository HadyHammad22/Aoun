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
    @IBOutlet weak var up: UIImageView!
    @IBOutlet weak var download: UIImageView!
    var post:Post!
    var likeRef:DatabaseReference!
    override func awakeFromNib() {
        super.awakeFromNib()
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeTap.numberOfTapsRequired = 1
        up.addGestureRecognizer(likeTap)
        
        let downloadTap = UITapGestureRecognizer(target: self, action: #selector(downloadTapped))
        downloadTap.numberOfTapsRequired = 1
        download.addGestureRecognizer(downloadTap)
        
    }
    func configureCell(post: Post, img:UIImage? = nil){
        
        self.post = post
        likeRef = DataService.db.REF_CURRENT_USERS.child("likes").child(post.postKey)
        self.postText.text = post.postText
        self.DonationType.text = post.type
        self.postImage.downloadImageUsingCache(imgUrl: post.imgUrl)
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.up.image = UIImage(named: "up_empty")
            }else{
                self.up.image = UIImage(named: "up_filled")
            }
        })
    }
    
    @objc func likeTapped(sender: UIGestureRecognizer){
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.up.image = UIImage(named: "up_filled")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            }else{
                self.up.image = UIImage(named: "up_empty")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
    
    @objc func downloadTapped(sender: UIGestureRecognizer){
        print("Download")
    }
    
}
