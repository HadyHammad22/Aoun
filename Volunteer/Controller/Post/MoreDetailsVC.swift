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
    @IBOutlet weak var postTextView: UIView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var downloadPDFBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    
    
    // MARK :- Instance Variables
    var post:Post?
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        callBtn.addBtnCornerRadius(20)
        callBtn.addBtnShadowWith(color: UIColor.black, radius: 2, opacity: 0.2)
        downloadPDFBtn.addBtnCornerRadius(20)
        downloadPDFBtn.addBtnShadowWith(color: UIColor.black, radius: 2, opacity: 0.2)
        chatBtn.addBtnCornerRadius(20)
        chatBtn.addBtnShadowWith(color: UIColor.black, radius: 2, opacity: 0.2)
        guard let post = post else {return}
        postImage.setImage(imageUrl: post.ImageUrl)
        postText.text = post.Text
        if post.PDFURL == "Empty"{
            self.downloadPDFBtn.isHidden = true
        }else{
            self.downloadPDFBtn.isHidden = false
        }
    }
    
    // MARK :- Actions
    @IBAction func dismissAction() {
        dismiss(animated: true)
    }
    
    @IBAction func buCall(_ sender: Any) {
        guard let post = self.post else {return}
        DataService.db.getUserWithId(id: post.Id, completion: { (user) in
            guard let user = user else {return}
            print(user.phone)
            guard let url = URL(string: "telprompt://\(user.phone)") else {return}
            UIApplication.shared.open(url)
        })
    }
    
    @IBAction func buChat(_ sender: Any) {
        guard let post = self.post else {return}
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.postOwnerID = post.Id
        let nav = UINavigationController(rootViewController: chatVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buDownloadPDF(_ sender: Any) {
        guard let post = self.post else {return}
        let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
        let localURL = tmporaryDirectoryURL.appendingPathComponent("sample.pdf")
        Storage.storage().reference(forURL: post.PDFURL).write(toFile: localURL) { (url, error) in
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
