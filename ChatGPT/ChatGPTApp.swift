//
//  ChatGPTApp.swift
//  ChatGPT
//
//  Created by iMac on 30/01/23.
//

import SwiftUI

@main
struct ChatGPTApp: App {
    
    @StateObject private var vm = ViewModel(api: ChatGPTAPI(apiKey: Constants.OPENAI_API_KEY))
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ChatView(vm: vm)
            }
        }
    }
}
