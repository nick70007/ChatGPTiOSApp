//
//  ChatView.swift
//  ChatGPT
//
//  Created by iMac on 30/01/23.
//

import SwiftUI

struct ChatView: View {
    
    // MARK: - Properties
    @State private var messages: [ChatMessage] = ChatMessage.chatMessages
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(messages) { message in
                        messageView(message: message)
                    }
                }
            }
            
            HStack {
                
            }
            
        }.padding()
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? .blue : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt { Spacer() }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
