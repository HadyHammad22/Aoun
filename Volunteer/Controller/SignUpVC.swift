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
    
    @IBOutlet weak var userName: CustomTextField!
    @IBOutlet weak var userEmail: CustomTextField!
    @IBOutlet weak var userPhone: CustomTextField!
    @IBOutlet weak var userCity: CustomTextField!
    @IBOutlet weak var userPwd: CustomTextField!
    @IBOutlet weak var userRePwd: CustomTextField!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    var gender:String? = "empty"
    
    let checked = UIImage(named: "radioSign 1x")
    let unChecked = UIImage(named: "unCheckRadioSign")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buSignUp(_ sender: Any) {
        guard let email = userEmail.text,
            let pwd    = userPwd.text,
            let phone  = userPhone.text,
            let city   = userCity.text,
            let name   = userName.text,
            let gender = gender else {return}
        
        let dataDict = ["name": name, "email": email, "password": pwd, "phone": phone, "city": city, "gender": gender]
        
        if validData(){
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (result, error) in
                if error == nil{
                    DataService.db.createFirebaseDBUser(uid: result!.user.uid, userData: dataDict)
                    self.showAlertsuccess(title: "User Created Successfully")
                    self.finishEnterData()
                    let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    self.present(login, animated: true, completion: nil)
                    
                }else{
                    self.showAlertWiring(title: "User can't created")
                }
                
            })
        }
    }
    
    @IBAction func buMale(_ sender: Any) {
        self.gender = "male"
        self.male.setImage(checked, for: .normal)
        self.female.setImage(unChecked, for: .normal)
    }
    
    @IBAction func buFemale(_ sender: Any) {
        self.gender = "female"
        self.female.setImage(checked, for: .normal)
        self.male.setImage(unChecked, for: .normal)
    }
    
    
    func validData() -> Bool {
        if userName.text! == ""{
            self.showAlertWiring(title: "Please enter the name to continue")
            return false
        }
        
        if userEmail.text! == ""{
            self.showAlertWiring(title: "Please enter the email to continue")
            return false
        }
        
        if !isValidEmail(testStr: userEmail.text!){
            self.showAlertWiring(title: "Please enter correct email format")
            return false
        }
        
        if userPhone.text! == ""{
            self.showAlertWiring(title: "Please enter the phone to continue")
            return false
        }
        
        if userCity.text! == ""{
            self.showAlertWiring(title: "Please enter the city to continue")
            return false
        }
        
        if userPwd.text! == ""{
            self.showAlertWiring(title: "Please enter the password to continue")
            return false
        }
        
        if userRePwd.text! == ""{
            self.showAlertWiring(title: "Please enter the password again to continue")
            return false
        }
        
        if userPwd.text! != userRePwd.text!{
            self.showAlertWiring(title: "Please check the password")
            return false
        }
        
        if gender == "empty"{
            self.showAlertWiring(title: "Please enter the Gender to continue")
            return false
        }
        
        return true
        
    }
    
    func finishEnterData(){
        self.userEmail.text = ""
        self.userName.text = ""
        self.userPwd.text = ""
        self.userRePwd.text = ""
        self.userCity.text = ""
        self.userPhone.text = ""
    }
    
}


extension LoginVC{
    // Function To Check The Email Validation
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

