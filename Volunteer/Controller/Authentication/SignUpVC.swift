//
//  ViewController.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/27/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> SignUpVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var nameTxtField: CustomTextField!
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var phoneTxtField: CustomTextField!
    @IBOutlet weak var cityTxtField: CustomTextField!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordVisibilityBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK :- Instance Variables
    var secure = true
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    override func viewDidLayoutSubviews() {
        topView.roundedFromSide(corners: [.bottomLeft], cornerRadius: 100)
    }
    
    // MARK :- SetupUI
    func setupComponents() {
        if Language.currentLanguage == .arabic {
            let attributedTitle = NSMutableAttributedString(string: "هل لديك حساب بالفعل؟ ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
            attributedTitle.append(NSAttributedString(string: "تسجيل الدخول", attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.selectedBorderColor]))
            loginBtn.setAttributedTitle(attributedTitle, for: .normal)
        }
        nameTxtField.delegate = self
        emailTxtField.delegate = self
        phoneTxtField.delegate = self
        cityTxtField.delegate = self
        passwordTxtField.delegate = self
        passwordView.addBorderWith(width: 1.5, color: UIColor.borderColor)
        passwordView.addCornerRadius(20)
        signUpBtn.addCornerRadius(20)
        signUpBtn.addBtnShadowWith(color: UIColor.black, radius: 2, opacity: 0.2)
    }
    
    // MARK :- Registertion
    @IBAction func buSignUp(_ sender: Any) {
        if validData() {
            guard let email = emailTxtField.text,
                let pwd    = passwordTxtField.text,
                let phone  = phoneTxtField.text,
                let city   = cityTxtField.text,
                let name   = nameTxtField.text else {return}
            
            let userData = ["name": name, "email": email, "password": pwd, "phone": phone, "city": city]
            DataService.db.signUp(userData: userData, onSuccess: { (user) in
                self.successCreated(user: user)
            }, onError: { (errorMessage) in
                self.showAlertError(title: "Register faild".localized)
            })
        }
    }
    
    func successCreated(user: User) {
        self.showAlertsuccess(title: "Register success".localized)
        UserDefaults.standard.set(user.uid, forKey: KEY_UID)
        self.finishEnterData()
        let nav = UINavigationController(rootViewController: MainTabBar.instance())
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func buLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    // MARK :- validations
    func validData() -> Bool {
        if nameTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter name".localized)
            return false
        }
        
        if phoneTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter phone".localized)
            return false
        }
        
        if cityTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter city".localized)
            return false
        }
        
        return true
    }
    
    func finishEnterData(){
        self.emailTxtField.text = ""
        self.nameTxtField.text = ""
        self.passwordTxtField.text = ""
        self.cityTxtField.text = ""
        self.phoneTxtField.text = ""
    }
    
}

extension SignUpVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTxtField{
            passwordView.layer.borderColor = UIColor.selectedBorderColor.cgColor
        }else{
            textField.layer.borderColor = UIColor.selectedBorderColor.cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTxtField{
            passwordView.layer.borderColor = UIColor.borderColor.cgColor
        }else{
            textField.layer.borderColor = UIColor.borderColor.cgColor
        }
    }
}
