//
//  OpenAICompletionsBody.swift
//  ChatGPT
//
//  Created by iMac on 31/01/23.
//

import Foundation

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}
