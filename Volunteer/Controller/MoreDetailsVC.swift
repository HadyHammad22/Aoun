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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postImage: CustomImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var downloadPDF: CustomButton!
    
    var post:Post?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = self.post else {return}
        postImage.downloadImageUsingCache(imgUrl: post.imgUrl)
        postText.text = post.postText
        titleLabel.text = post.type
        if post.pdfUrl == "Empty"{
            self.downloadPDF.isHidden = true
        }else{
            self.downloadPDF.isHidden = false
        }
    }
    
    @IBAction func buCall(_ sender: Any) {
        
        guard let post = self.post else {return}
        self.loadData(id: post.id, completion: { (user) in
            guard let user = user else {return}
            print(user.phone)
            guard let url = URL(string: "telprompt://\(user.phone)") else {return}
            UIApplication.shared.open(url)
        })
        
    }
    
    @IBAction func buChat(_ sender: Any) {
        
        guard let post = self.post else {return}
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        chatVC.postOwnerID = post.id
        let nav = UINavigationController(rootViewController: chatVC)
        self.present(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func buDownloadPDF(_ sender: Any) {
        
        guard let post = self.post else {return}
        let tmporaryDirectoryURL = FileManager.default.temporaryDirectory
        let localURL = tmporaryDirectoryURL.appendingPathComponent("sample.pdf")
        
        Storage.storage().reference(forURL: post.pdfUrl).write(toFile: localURL) { url, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                print(url!)
                self.presentActivityViewController(withUrl: url!)
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
    
    func loadData(id: String,completion: @escaping (_ user: User?)->()){
        DataService.db.REF_USERS.child(id).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? Dictionary<String,Any> else{return}
            let user = User(userData: data)
            completion(user)
        })
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
