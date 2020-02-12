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
    
    @IBOutlet weak var email:CustomTextField!
    @IBOutlet weak var name: CustomTextField!
    @IBOutlet weak var city: CustomTextField!
    @IBOutlet weak var phone: CustomTextField!
    @IBOutlet weak var nameShow: UILabel!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var male: UIButton!
    @IBOutlet weak var female: UIButton!
    @IBOutlet weak var saveBtn: CustomButton!
    
    var gender:String? = "empty"
    
    let checked = UIImage(named: "radioSign 1x")
    let unChecked = UIImage(named: "unCheckRadioSign")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfile()
    }
    
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
            self.email.text = user.email
            self.name.text = user.name
            self.city.text = user.city
            self.phone.text = user.phone
            self.password.text = user.password
            self.nameShow.text = "@ \(user.name)"
            
            if user.gender == "Male"{
                self.gender = "Male"
                self.male.setImage(self.checked, for: .normal)
                self.female.setImage(self.unChecked, for: .normal)
            }else if user.gender == "Female"{
                self.gender = "Female"
                self.female.setImage(self.checked, for: .normal)
                self.male.setImage(self.unChecked, for: .normal)
            }
            
        })
    }
    
    @IBAction func buMale(_ sender: Any) {
        self.gender = "Male"
        self.male.setImage(checked, for: .normal)
        self.female.setImage(unChecked, for: .normal)
    }
    @IBAction func buFemale(_ sender: Any) {
        self.gender = "Female"
        self.female.setImage(checked, for: .normal)
        self.male.setImage(unChecked, for: .normal)
    }
    @IBAction func buSave(_ sender: Any) {
        guard let email = email.text,
            let pwd    = password.text,
            let phone  = phone.text,
            let city   = city.text,
            let name   = name.text,
            let uid    = UserDefaults.standard.string(forKey: KEY_UID),
            let gender = gender else {return}
        
        let dataDict = ["name": name, "email": email, "password": pwd, "phone": phone, "city": city, "gender": gender]
        DataService.db.REF_USERS.child(uid).updateChildValues(dataDict, withCompletionBlock: { (error, result) in
            if error == nil{
                self.showAlertsuccess(title: "Profile Updated Successfully")
                self.disableComponent()
            }else{
                self.showAlertWiring(title: "Profile Can't Update")
            }
        })
    }
    @IBAction func buEdit(_ sender: Any) {
        enableComponent()
    }
    
    func enableComponent(){
        saveBtn.isUserInteractionEnabled = true
        email.isUserInteractionEnabled = true
        name.isUserInteractionEnabled = true
        city.isUserInteractionEnabled = true
        phone.isUserInteractionEnabled = true
        password.isUserInteractionEnabled = true
        male.isUserInteractionEnabled = true
        female.isUserInteractionEnabled = true
    }
    
    func disableComponent(){
        saveBtn.isUserInteractionEnabled = false
        email.isUserInteractionEnabled = false
        name.isUserInteractionEnabled = false
        city.isUserInteractionEnabled = false
        phone.isUserInteractionEnabled = false
        password.isUserInteractionEnabled = false
        male.isUserInteractionEnabled = false
        female.isUserInteractionEnabled = false
    }
    
}
