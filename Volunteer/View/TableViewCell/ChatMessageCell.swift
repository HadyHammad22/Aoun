//
//  ChatMessageCell.swift
//  Volunteer
//
//  Created by Hady Hammad on 9/21/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    enum BubbleType {
        case incoming
        case outgoing
    }
    
    @IBOutlet weak var chatText: UITextView!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var chatView: CustomView!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    func configureCell(message: Message, type: BubbleType){
        if let msgText = message.text{
            self.chatText.text = msgText
            setupAllignment(bubbleType: type)
        }
        
        if let imageUrl = message.imageUrl{
            print(imageUrl)
            chatText.text = "Image..."
            setupAllignment(bubbleType: type)
        }
    }
    
    func setupAllignment(bubbleType: BubbleType){
        if bubbleType == .incoming{
            self.chatStack.alignment = .leading
            self.chatView.backgroundColor = CHAT_INCOMING_COLOR
            self.chatText.textColor = UIColor.black
            
        }else{
            self.chatStack.alignment = .trailing
            self.chatView.backgroundColor = CHAT_OUTGOING_COLOR
            self.chatText.textColor = UIColor.white
        }
    }
}
