//
//  ChatMessage.swift
//  ChatGPT
//
//  Created by iMac on 30/01/23.
//

import Foundation

enum MessageSender {
    case me
    case gpt
}

struct ChatMessage: Identifiable {
    let id: String
    let content: String
    let dateCreated = Date()
    let sender: MessageSender
}
