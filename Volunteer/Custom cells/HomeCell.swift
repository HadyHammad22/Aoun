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
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postTimeLbl: UILabel!
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
        userImage.addCornerRadius(userImage.frame.height / 2)
        postTextBackView.addCornerRadius(5)
        postTextBackView.addBorderWith(width: 0.3, color: .darkGray)
    }
    
    func configureCell(post: Post){
        self.post = post
        likeRef = DataService.db.REF_CURRENT_USERS.child("likes").child(post.postKey!)
        self.postTextView.text = post.postText!
        self.donationTypeLbl.text = post.type!
        self.postImageView.setImage(imageUrl: post.imgUrl!)
        self.postTimeLbl.text = post.createdAt?.calendarTimeSinceNow()
        DataService.db.getUserWithId(id: post.id!, completion: { (user) in
            self.userNameLbl.text = user?.name
        })
        setupLikes()
    }
    
    func setupLikes() {
        likeRef.observe(.value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeBtn.setImage(UIImage(named: "dislike"), for: .normal)
            }else{
                self.likeBtn.setImage(UIImage(named: "like"), for: .normal)
            }
        })
    }
    
    // MARK :- Actions
    @IBAction func buLikeClicked(_ sender: Any) {
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likeBtn.setImage(UIImage(named: "like"), for: .normal)
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            }else{
                self.likeBtn.setImage(UIImage(named: "dislike"), for: .normal)
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
    
}
