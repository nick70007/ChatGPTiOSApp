//
//  ChatMessage.swift
//  ChatGPT
//
//  Created by iMac on 30/01/23.
//

import Foundation

struct CompletionResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let text: String
}

