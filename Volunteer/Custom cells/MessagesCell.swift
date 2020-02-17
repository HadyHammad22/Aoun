//
//  MessagesCell.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/22/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var msg: UILabel!
    
    func configureCell(message: Message){
        self.msg.text = message.text
        DataService.db.getUserWithId(id: message.fromId!, completion: { user in
            self.name.text = user!.name
        })
    }
    
}
