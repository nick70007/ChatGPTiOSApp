//
//  OpenAICompletionsResponse.swift
//  ChatGPT
//
//  Created by iMac on 31/01/23.
//

import Foundation

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoice]
}
