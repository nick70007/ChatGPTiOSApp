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
    let id = UUID().uuidString
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

extension ChatMessage {
    
    static let chatMessages = [
        ChatMessage(content: "Sample Message From Me", dateCreated: Date(), sender: .me),
        ChatMessage(content: "Sample Message From GPT", dateCreated: Date(), sender: .gpt),
        ChatMessage(content: "Sample Message From Me", dateCreated: Date(), sender: .me),
        ChatMessage(content: "Sample Message From GPT", dateCreated: Date(), sender: .gpt)
    
    ]
    
}
