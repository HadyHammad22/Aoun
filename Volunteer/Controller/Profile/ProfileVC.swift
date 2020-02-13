//
//  ProfileVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/29/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class ProfileVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> ProfileVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var emailTxtField:UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imageEditView: UIView!
    @IBOutlet weak var imageEditBtn: UIButton!
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        configureProfile()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        saveBtn.addBtnCornerRadius(20)
        saveBtn.addBtnNormalShadow()
        signOutBtn.addBtnCornerRadius(20)
        signOutBtn.addBtnNormalShadow()
        userImage.addCornerRadius(userImage.frame.height/2)
        imageEditView.addCornerRadius(imageEditView.frame.height/2)
        imageEditBtn.addBtnCornerRadius(imageEditBtn.frame.height/2)
    }
    
    // MARK :- Load Profile
    func loadData(completion: @escaping (_ user: User?)->()){
        guard let uid = UserDefaults.standard.string(forKey: KEY_UID) else{return}
        DataService.db.REF_USERS.child(uid).observe(.value, with: { (snapshot) in
            guard let data = snapshot.value as? Dictionary<String,Any> else{return}
            let user = User(userData: data)
            completion(user)
        })
    }
    
    func configureProfile(){
        self.loadData(completion: { (user) in
            guard let user = user else{return}
            self.emailTxtField.text = user.email
            self.nameTxtField.text = user.name
            self.cityTxtField.text = user.city
            self.phoneTxtField.text = user.phone
            self.passwordTxtField.text = user.password
        })
    }
    
    // MARK :- Save
    @IBAction func buSave(_ sender: Any) {
        guard let email = emailTxtField.text,
            let pwd    = passwordTxtField.text,
            let phone  = phoneTxtField.text,
            let city   = cityTxtField.text,
            let name   = nameTxtField.text,
            let uid    = UserDefaults.standard.string(forKey: KEY_UID) else {return}
        
        let dataDict = ["name": name, "email": email, "password": pwd, "phone": phone, "city": city]
        DataService.db.REF_USERS.child(uid).updateChildValues(dataDict, withCompletionBlock: { (error, result) in
            if error == nil{
                self.showAlertsuccess(title: "Update success")
            }else{
                self.showAlertWiring(title: "Update faild")
            }
        })
    }
    
    @IBAction func buSignOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        self.present(LoginVC.instance(), animated: true, completion: nil)
    }
}
