//
//  ResetPasswordVC.swift
//  Volunteer
//
//  Created by Hady Hammad on 2/22/20.
//  Copyright © 2020 Hady Hammad. All rights reserved.
//

import UIKit

class ResetPasswordVC: BaseViewController {
    
    static func instance () -> ResetPasswordVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
    }
    
    @IBOutlet weak var emailTxtField: CustomTextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        setupComponents()
    }
    
    override func viewDidLayoutSubviews() {
        self.topView.roundedFromSide(corners: [.bottomLeft], cornerRadius: 100)
    }
    
    func setupComponents(){
        resetBtn.addCornerRadius(5)
        topView.addShadowWith(color: UIColor.black, radius: 5, opacity: 0.6)
    }
    
    @IBAction func buResetPassword(_ sender: Any) {
        if validData() {
            DataService.db.resetPassword(email: emailTxtField.text!, onSuccess: {
                self.showAlertsuccess(title: "please check your email inbox")
                self.dismiss(animated: true, completion: nil)
            }, onError: { (errorMessage) in
                self.showAlertError(title: errorMessage)
            })
        }
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func validData() -> Bool{
        if emailTxtField.text!.isEmpty{
            self.showAlertWiring(title: "Please enter email")
            return false
        }
        if !(emailTxtField.text!.isValidEmail){
            self.showAlertWiring(title: "Enter valid email")
            return false
        }
        return true
    }
    
}

extension ResetPasswordVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.selectedBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.borderColor.cgColor
    }
}
