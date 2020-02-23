//
//  ProfileVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/29/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class ProfileVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> ProfileVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var emailTxtField:CustomTextField!
    @IBOutlet weak var nameTxtField: CustomTextField!
    @IBOutlet weak var cityTxtField: CustomTextField!
    @IBOutlet weak var phoneTxtField: CustomTextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var imageEditView: UIView!
    @IBOutlet weak var imageEditBtn: UIButton!
    @IBOutlet weak var passwordVisibilityBtn: UIButton!
    
    // MARK :- Instance Variables
    var secure = true
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        configureProfile()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        passwordView.addBorderWith(width: 1, color: .borderColor)
        passwordView.addCornerRadius(20)
        saveBtn.addBtnCornerRadius(22)
        saveBtn.addBtnNormalShadow()
        signOutBtn.addBtnCornerRadius(22)
        signOutBtn.addBtnNormalShadow()
        userImage.addCornerRadius(userImage.frame.height/2)
        imageEditView.addCornerRadius(imageEditView.frame.height/2)
        imageEditBtn.addBtnCornerRadius(imageEditBtn.frame.height/2)
    }
    
    // MARK :- Load Profile
    func configureProfile() {
        guard let uid = UserDefaults.standard.string(forKey: KEY_UID) else{return}
        ProgressHUD.show()
        DataService.db.getUserWithId(id: uid, completion: { (user) in
            ProgressHUD.dismiss()
            guard let user = user else{return}
            DispatchQueue.main.async {
                self.emailTxtField.text = user.email
                self.nameTxtField.text = user.name
                self.cityTxtField.text = user.city
                self.phoneTxtField.text = user.phone
                self.passwordTxtField.text = user.password
            }
        })
    }
    
    // MARK :- Save
    @IBAction func buSave(_ sender: Any) {
        if saveBtn.title(for: .normal) == "Edit" {
            interactionEnable()
        }else{
            guard let email = emailTxtField.text,
                let pwd    = passwordTxtField.text,
                let phone  = phoneTxtField.text,
                let city   = cityTxtField.text,
                let name   = nameTxtField.text else {return}
            
            let userData = ["name": name, "email": email, "password": pwd, "phone": phone, "city": city]
            DataService.db.updateProfile(userData: userData, onSuccess: {
                self.showAlertsuccess(title: "Update success")
                self.interactionDisable()
            }, onError: { (errorMessage) in
                print(errorMessage)
                self.showAlertWiring(title: "Update faild")
            })
        }
    }
    
    func interactionEnable() {
        saveBtn.setTitle("Save", for: .normal)
        nameTxtField.isUserInteractionEnabled = true
        emailTxtField.isUserInteractionEnabled = true
        phoneTxtField.isUserInteractionEnabled = true
        cityTxtField.isUserInteractionEnabled = true
        passwordTxtField.isUserInteractionEnabled = true
        imageEditBtn.isUserInteractionEnabled = true
        passwordVisibilityBtn.isUserInteractionEnabled = true
        nameTxtField.addBorderWith(width: 1, color: .selectedBorderColor)
        emailTxtField.addBorderWith(width: 1, color: .selectedBorderColor)
        phoneTxtField.addBorderWith(width: 1, color: .selectedBorderColor)
        cityTxtField.addBorderWith(width: 1, color: .selectedBorderColor)
        passwordView.addBorderWith(width: 1, color: .selectedBorderColor)
    }
    
    func interactionDisable() {
        saveBtn.setTitle("Edit", for: .normal)
        nameTxtField.isUserInteractionEnabled = false
        emailTxtField.isUserInteractionEnabled = false
        phoneTxtField.isUserInteractionEnabled = false
        cityTxtField.isUserInteractionEnabled = false
        passwordTxtField.isUserInteractionEnabled = false
        imageEditBtn.isUserInteractionEnabled = false
        passwordVisibilityBtn.isUserInteractionEnabled = false
        nameTxtField.addBorderWith(width: 1, color: .borderColor)
        emailTxtField.addBorderWith(width: 1, color: .borderColor)
        phoneTxtField.addBorderWith(width: 1, color: .borderColor)
        cityTxtField.addBorderWith(width: 1, color: .borderColor)
        passwordView.addBorderWith(width: 1, color: .borderColor)
    }
    
    @IBAction func buPasswordVisibility(_ sender: Any) {
        if secure{
            passwordTxtField.isSecureTextEntry = false
            secure = false
            passwordVisibilityBtn.setImage(UIImage(named: "visibility"), for: .normal)
        }else{
            passwordTxtField.isSecureTextEntry = true
            secure = true
            passwordVisibilityBtn.setImage(UIImage(named: "visibility_off"), for: .normal)
        }
    }
    
    @IBAction func buSignOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        self.present(LoginVC.instance(), animated: true, completion: nil)
    }
}
