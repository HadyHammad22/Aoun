//
//  LoginVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/27/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
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
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        setupComponents()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        topView.roundedFromSide(corners: [.bottomLeft], cornerRadius: 100)
        loginBtn.addCornerRadius(20)
        loginBtn.addBtnShadowWith(color: UIColor.black, radius: 2, opacity: 0.2)
    }

    // MARK :- Login
    @IBAction func buLogin(_ sender: Any) {
        if validData(){
            guard let email = emailTxtField.text, let pwd = passwordTxtField.text else{return}
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (result, error) in
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
