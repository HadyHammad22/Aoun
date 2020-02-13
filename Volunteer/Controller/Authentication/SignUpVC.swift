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
    @IBOutlet weak var signUpBtn: UIButton!
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
        nameTxtField.delegate = self
        emailTxtField.delegate = self
        phoneTxtField.delegate = self
        cityTxtField.delegate = self
        passwordTxtField.delegate = self
        topView.roundedFromSide(corners: [.bottomLeft], cornerRadius: 100)
        signUpBtn.addCornerRadius(20)
        signUpBtn.addBtnShadowWith(color: UIColor.black, radius: 2, opacity: 0.2)
    }
    
    // MARK :- Registertion
    @IBAction func buSignUp(_ sender: Any) {
        guard let email = emailTxtField.text,
            let pwd    = passwordTxtField.text,
            let phone  = phoneTxtField.text,
            let city   = cityTxtField.text,
            let name   = nameTxtField.text else {return}
        
        let dataDict = ["name": name, "email": email, "password": pwd, "phone": phone, "city": city]
        
        if validData(){
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (result, error) in
                if error == nil{
                    DataService.db.createFirebaseDBUser(uid: result!.user.uid, userData: dataDict)
                    self.showAlertsuccess(title: "Sign up success")
                    self.finishEnterData()
                    let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.present(login, animated: true, completion: nil)
                    
                }else{
                    self.showAlertWiring(title: "Sign up faild")
                }
                
            })
        }
    }
    @IBAction func buLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK :- validations
    func validData() -> Bool {
        if nameTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter the name")
            return false
        }
        
        if emailTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter the email")
            return false
        }
        
        if !(emailTxtField.text!.isValidEmail){
            self.showAlertWiring(title: "Enter valid email")
            return false
        }
        
        if phoneTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter the phone")
            return false
        }
        
        if cityTxtField.text! == ""{
            self.showAlertWiring(title: "Please enter the city")
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
        self.nameTxtField.text = ""
        self.passwordTxtField.text = ""
        self.cityTxtField.text = ""
        self.phoneTxtField.text = ""
    }
    
}
