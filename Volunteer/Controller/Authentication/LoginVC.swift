//
//  LoginVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/27/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class LoginVC:BaseViewController {
    
    // MARK :- Instance
    static func instance () -> LoginVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordVisibilityBtn: UIButton!
    
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
    func setupComponents(){
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        loginBtn.addCornerRadius(20)
        loginBtn.addBtnShadowWith(color: UIColor.black, radius: 2, opacity: 0.2)
        passwordView.addBorderWith(width: 1.5, color: UIColor.borderColor)
        passwordView.addCornerRadius(20)
    }
    
    // MARK :- Login
    @IBAction func buLogin(_ sender: Any) {
        if validData(){
            ProgressHUD.show()
            guard let email = emailTxtField.text, let pwd = passwordTxtField.text else{return}
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (result, error) in
                ProgressHUD.dismiss()
                if error == nil{
                    self.showAlertsuccess(title: "Login Success")
                    UserDefaults.standard.set(result!.user.uid, forKey: KEY_UID)
                    self.finishEnterData()
                    let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.present(home, animated: true, completion: nil)
                }else{
                    self.showAlertWiring(title: "User not exist please Sign Up ")
                    return
                }
            })
        }
    }
    @IBAction func buRegister(_ sender: Any) {
        self.present(SignUpVC.instance(), animated: true, completion: nil)
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
    
    // MARK :- Validations
    func validData() -> Bool {
        if emailTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter the email")
            return false
        }
        
        if !(emailTxtField.text!.isValidEmail){
            self.showAlertWiring(title: "Enter valid email")
            return false
        }
        
        if passwordTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter the password")
            return false
        }
        return true
    }
    
    func finishEnterData(){
        self.emailTxtField.text = ""
        self.passwordTxtField.text = ""
    }
    
}

extension LoginVC: UITextFieldDelegate{
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
