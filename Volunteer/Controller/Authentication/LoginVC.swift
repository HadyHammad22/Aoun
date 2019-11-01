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
    
    @IBOutlet weak var email: LoginCustomTextField!
    @IBOutlet weak var password: LoginCustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = UserDefaults.standard.string(forKey: KEY_UID){
            let home = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.present(home, animated: true, completion: nil)
        }
    }
    
    @IBAction func buLogin(_ sender: Any) {
        print("DSA")
        if validData(){
            guard let email = email.text, let pwd = password.text else{return}
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (result, error) in
                print("ASD")
                if error == nil{
                    self.showAlertsuccess(title: "Login Successfully")
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
    
    @IBAction func buLoginWithFacebook(_ sender: Any) {
        print("Login With Facebook")
    }
    
    func validData() -> Bool {
        
        if email.text! == ""{
            self.showAlertWiring(title: "Please enter the email")
            return false
        }
        
        if !isValidEmail(testStr: email.text!){
            self.showAlertWiring(title: "Please enter correct email format")
            return false
        }
        
        if password.text! == ""{
            self.showAlertWiring(title: "Please enter the password")
            return false
        }
        
        return true
    }
    
    func finishEnterData(){
        self.email.text = ""
        self.password.text = ""
    }
    
}


extension SignUpVC{
    // Function To Check The Email Validation
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
