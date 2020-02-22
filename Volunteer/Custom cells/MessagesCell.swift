//
//  MessagesCell.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/22/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    // MARK :- Outlets
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userMessageLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    // MARK :- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupComponents()
    }
    
    // MARK :- SetupUI
    func setupComponents(){
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
    }
    
    func configureCell(message: Message){
        self.userMessageLbl.text = message.text
        if let id = message.partnerID() {
            DataService.db.getUserWithId(id: id, completion: { user in
                self.userNameLbl.text = user!.name
            })
        }
    }
    
}
