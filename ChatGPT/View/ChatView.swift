//
//  ChatView.swift
//  ChatGPT
//
//  Created by iMac on 30/01/23.
//

import SwiftUI
import Combine

struct ChatView: View {
    
    // MARK: - Properties
    @State private var messages: [ChatMessage] = []
    @State private var messageText = ""
    @State private var cancellables = Set<AnyCancellable>()
    let service = OpenAIService()
    
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
                TextField("Enter a message ...", text: $messageText) {
                    sendMessage()
                }
                .autocapitalization(.none)
                .disableAutocorrection(false)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Button {
                    self.sendMessage()
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
            
        }
        .padding()
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
    
    func sendMessage() {
        
        let myMessage = ChatMessage(id: UUID().uuidString,
                                    content: messageText,
                                    sender: .me)
        messages.append(myMessage)
        
        service.send(messageText).sink { completion in
            
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let gptMessage = ChatMessage(id: response.id,
                                         content: textResponse,
                                         sender: .gpt)
            messages.append(gptMessage)
        }
        .store(in: &cancellables)

        messageText = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
