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
    
    // MARK :- Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var donationTypeLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var postTextBackView: UIView!
    
    // MARK :- Instance Variables
    var post:Post!
    var likeRef:DatabaseReference!
    
    // MARK :- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupComponents()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        shadowView.addCornerRadius(10)
        shadowView.addNormalShadow()
        postTextBackView.addCornerRadius(8)
        postTextBackView.addBorderWith(width: 0.5, color: .darkGray)
    }
    
    func configureCell(post: Post, img:UIImage? = nil){
        self.post = post
        likeRef = DataService.db.REF_CURRENT_USERS.child("likes").child(post.postKey)
        self.postTextView.text = post.postText
        self.donationTypeLbl.text = post.type
        self.postImageView.downloadImageUsingCache(imgUrl: post.imgUrl)
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeBtn.setImage(UIImage(named: "favorite"), for: .normal)
            }else{
                self.likeBtn.setImage(UIImage(named: "favorite-1"), for: .normal)
            }
        })
    }
    
    // MARK :- Actions
    @IBAction func buLikeClicked(_ sender: Any) {
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeBtn.setImage(UIImage(named: "favorite-1"), for: .normal)
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            }else{
                self.likeBtn.setImage(UIImage(named: "favorite"), for: .normal)
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
    
}
