//
//  MoreDetailsVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 11/1/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase

class MoreDetailsVC: UIViewController {
    
    // MARK :- Instance
    static func instance () -> MoreDetailsVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MoreDetailsVC") as! MoreDetailsVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postTextHeight: NSLayoutConstraint!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var sendMessageView: UIView!
    @IBOutlet weak var attachmentBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userLocationLbl: UILabel!
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK :- Instance Variables
    var post:Post?
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        setupUI()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        let origImage = UIImage(named: "arrow_back")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tintedImage, for: .normal)
        backBtn.tintColor = .selectedBorderColor
        callView.addCornerRadius(22)
        sendMessageView.addCornerRadius(22)
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
        sendMessageView.addBorderWith(width: 2, color: .selectedBorderColor)
        callView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(makeCall)))
        sendMessageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMessage)))
        changeImageTint()
        guard let uid = Auth.auth().currentUser?.uid, let postOwnerID = post?.userID else{return}
        if uid == postOwnerID {
            callView.isUserInteractionEnabled = false
            sendMessageView.isUserInteractionEnabled = false
        }
    }
    
    func changeImageTint() {
        let origImage = UIImage(named: "phone")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        callImage.image = tintedImage
        callImage.tintColor = .white
    }
    func setupUI(){
        DispatchQueue.main.async {
            guard let post = self.post, let uid = post.userID else{return}
            self.postImage.setImage(imageUrl: post.imgUrl!)
            self.postText.text = post.postText!
            self.postTextHeight.constant = self.postText.contentSize.height
            if let _ = post.pdfUrl{
                self.attachmentBtn.isHidden = false
            }else{
                self.attachmentBtn.isHidden = true
            }
            DataService.db.getUserWithId(id: uid, completion: { (user) in
                self.userNameLbl.text = user?.name
                self.userLocationLbl.text = user?.city
            })
        }
    }
    
    // MARK :- Actions
    @IBAction func dismissAction() {
        dismiss(animated: true)
    }
    
    @objc func makeCall(){
        guard let post = self.post, let uid = post.userID else{return}
        DataService.db.getUserWithId(id: uid, completion: { (user) in
            guard let user = user else {return}
            print(user.phone)
            guard let url = URL(string: "telprompt://\(user.phone)") else {return}
            UIApplication.shared.open(url)
        })
    }
    
    @objc func sendMessage(){
        guard let post = self.post, let uid = post.userID else{return}
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.postOwnerID = uid
        let nav = UINavigationController(rootViewController: chatVC)
        self.present(nav, animated: true, completion: nil)
    }
   
    @IBAction func buDownloadPDF(_ sender: Any) {
        guard let post = self.post else {return}
        let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
        let localURL = tmporaryDirectoryURL.appendingPathComponent("sample.pdf")
        Storage.storage().reference(forURL: post.pdfUrl!).write(toFile: localURL) { (url, error) in
            if error == nil {
                guard let url = url else{return}
                self.presentActivityViewController(withUrl: url)
            }
        }
    }
    
    func presentActivityViewController(withUrl url: URL) {
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
}
