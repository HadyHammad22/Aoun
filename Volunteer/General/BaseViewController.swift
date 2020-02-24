//
//  BaseViewController.swift
//  Volunteer
//
//  Created by Hady Hammad on 8/28/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable{
    
    //MARK: Alerts
    func showAlertWiring(title: String, body: String = "") {
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        
        msgView.configureContent(title: title, body: body)
        msgView.configureTheme(.warning)
        msgView.button?.isHidden = true
        msgView.configureDropShadow()
        msgView.titleLabel?.textAlignment = .center
        msgView.bodyLabel?.textAlignment = .center
        
        msgView.titleLabel?.adjustsFontSizeToFitWidth = true
        msgView.bodyLabel?.adjustsFontSizeToFitWidth = true
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = SwiftMessages.Duration.seconds(seconds: 2)
        
        SwiftMessages.show(config: config, view: msgView)
    }
    
    func showAlertError(title: String, body: String = "") {
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        
        msgView.configureContent(title: title, body: body)
        msgView.configureTheme(.error)
        msgView.button?.isHidden = true
        msgView.configureDropShadow()
        msgView.titleLabel?.textAlignment = .center
        msgView.bodyLabel?.textAlignment = .center
        
        msgView.titleLabel?.adjustsFontSizeToFitWidth = true
        msgView.bodyLabel?.adjustsFontSizeToFitWidth = true
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = SwiftMessages.Duration.seconds(seconds: 2)
        
        SwiftMessages.show(config: config, view: msgView)
    }
    
    func showAlertsuccess(title: String, body: String = "") {
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        
        msgView.configureContent(title: title, body: body)
        msgView.configureTheme(.success)
        msgView.button?.isHidden = true
        msgView.configureDropShadow()
        msgView.titleLabel?.textAlignment = .center
        msgView.bodyLabel?.textAlignment = .center
        
        msgView.titleLabel?.adjustsFontSizeToFitWidth = true
        msgView.bodyLabel?.adjustsFontSizeToFitWidth = true
        
        var config = SwiftMessages.defaultConfig
        
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        config.duration = SwiftMessages.Duration.seconds(seconds: 1.5)
        
        SwiftMessages.show(config: config, view: msgView)
    }
    
    func showLoadingIndicator() {
        let size = CGSize(width: 50, height: 50)
        startAnimating(size, type: .ballClipRotate, color: UIColor.blue, backgroundColor: UIColor.clear, textColor: UIColor.black, fadeInAnimation: nil)
    }
    
    func hideLoadingIndicator() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
}
