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
    static func instance () -> SignUpVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var emailTxtField:CustomTextField!
    @IBOutlet weak var nameTxtField: CustomTextField!
    @IBOutlet weak var cityTxtField: CustomTextField!
    @IBOutlet weak var phoneTxtField: CustomTextField!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        configureProfile()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        nameTxtField.delegate = self
        emailTxtField.delegate = self
        phoneTxtField.delegate = self
        cityTxtField.delegate = self
        passwordTxtField.delegate = self
        userImage.addCornerRadius(userImage.frame.height/2)
        backView.addCornerRadius(10)
        backView.addNormalShadow()
        saveBtn.addBtnCornerRadius(10)
        saveBtn.addBtnNormalShadow()
        editBtn.addBtnCornerRadius(10)
        editBtn.addBtnNormalShadow()
    }
    
    func enableComponent(){
        saveBtn.isUserInteractionEnabled = true
        emailTxtField.isUserInteractionEnabled = true
        nameTxtField.isUserInteractionEnabled = true
        cityTxtField.isUserInteractionEnabled = true
        phoneTxtField.isUserInteractionEnabled = true
        passwordTxtField.isUserInteractionEnabled = true
    }
    
    func disableComponent(){
        saveBtn.isUserInteractionEnabled = false
        emailTxtField.isUserInteractionEnabled = false
        nameTxtField.isUserInteractionEnabled = false
        cityTxtField.isUserInteractionEnabled = false
        phoneTxtField.isUserInteractionEnabled = false
        passwordTxtField.isUserInteractionEnabled = false
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
            self.userNameLbl.text = "@ \(user.name)"
            
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
                self.showAlertsuccess(title: "Profile Updated Successfully")
                self.disableComponent()
            }else{
                self.showAlertWiring(title: "Profile Can't Update")
            }
        })
    }
    
    // MARK :- Edit
    @IBAction func buEdit(_ sender: Any) {
        enableComponent()
    }
    
}
